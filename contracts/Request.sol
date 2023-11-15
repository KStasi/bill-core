// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

contract Request is UUPSUpgradeable, Initializable {
    enum Status {
        Pending,
        Cancelled,
        Accepted
    }

    struct RequestData {
        string requestType;
        Status status;
        string ipfsHash;
    }

    RequestData public requestData;
    address public payer;
    address public payee;
    address public immutable storageManager;
    uint256 public amount;

    event RequestCreated(address storageManager);
    event RequestCancelled();
    event RequestAccepted();
    event RequestAmountEdited(uint256 amount);
    event RequestInitialized(
        string requestType,
        string ipfsHash,
        address indexed payer,
        address indexed payee,
        uint256 amount
    );

    constructor(address _storageManager) {
        storageManager = _storageManager;
        emit RequestCreated(_storageManager);
        _disableInitializers();
    }

    function initialize(
        string memory _type,
        string memory _ipfsHash,
        address _payer,
        address _payee,
        uint256 _amount
    ) public virtual initializer {
        _initialize(_type, _ipfsHash, _payer, _payee, _amount);
    }

    function _initialize(
        string memory _type,
        string memory _ipfsHash,
        address _payer,
        address _payee,
        uint256 _amount
    ) internal virtual {
        requestData = RequestData({
            requestType: _type,
            status: Status.Pending,
            ipfsHash: _ipfsHash
        });
        payer = _payer;
        payee = _payee;
        amount = _amount;
        emit RequestInitialized(_type, _ipfsHash, _payer, _payee, _amount);
    }

    modifier onlyAuthorized(
        string memory action,
        bytes memory data,
        bytes memory signature
    ) {
        require(
            _isAuthorized(action, data, signature),
            "Not authorized or invalid signature"
        );
        _;
    }

    modifier onlyPayerAuthorized(string memory action, bytes memory signature) {
        require(
            msg.sender == payer ||
                _isValidSignature(
                    getMessageHash(action, "0x"),
                    signature,
                    payer
                ),
            "Only payer can perform this action"
        );
        _;
    }

    function getMessageHash(
        string memory action,
        bytes memory data
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), action, data));
    }

    function _isValidSignature(
        bytes32 messageHash,
        bytes memory signature,
        address signer
    ) private pure returns (bool) {
        bytes32 prefixedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );
        address recoveredAddress = ECDSA.recover(prefixedHash, signature);
        return recoveredAddress == signer;
    }

    function _isAuthorized(
        string memory action,
        bytes memory data,
        bytes memory signature
    ) private view returns (bool) {
        bytes32 messageHash = getMessageHash(action, data);
        return
            msg.sender == payer ||
            msg.sender == payee ||
            _isValidSignature(messageHash, signature, payer) ||
            _isValidSignature(messageHash, signature, payee);
    }

    function cancel(
        bytes memory signature
    ) external onlyAuthorized("cancel", "0x", signature) {
        requestData.status = Status.Cancelled;
        emit RequestCancelled();
    }

    function accept(
        bytes memory signature
    ) external onlyPayerAuthorized("accept", signature) {
        requestData.status = Status.Accepted;
        emit RequestAccepted();
    }

    function edit(
        uint256 _amount,
        bytes memory signature
    ) external onlyAuthorized("edit", abi.encode(_amount), signature) {
        amount = _amount;
        emit RequestAmountEdited(_amount);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal view override {
        (newImplementation);
        require(false);
    }
}
