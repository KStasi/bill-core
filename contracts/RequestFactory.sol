// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "./Request.sol";

contract RequestFactory {
    Request public immutable requestImplementation;

    event RequestDeployed(
        address indexed newRequest,
        string requestType,
        string ipfsHash,
        address indexed payer,
        address indexed payee,
        uint256 amount
    );

    constructor(address _storageManager) {
        requestImplementation = new Request(_storageManager);
    }

    // Description: Deploys a new document
    // requestType: "bill", "invoice", "receipt", "refund" etc.
    // ipfsHash: IPFS hash of the request
    // payer: address of the payer
    // payee: address of the payee
    // asset: address of the asset
    // amount: amount of the asset
    // salt: salt for the address computation
    function createRequest(
        string memory requestType,
        string memory ipfsHash,
        address payer,
        address payee,
        address asset,
        uint256 amount,
        uint256 salt
    ) public returns (Request ret) {
        address addr = getAddress(
            requestType,
            ipfsHash,
            payer,
            payee,
            asset,
            amount,
            salt
        );
        uint codeSize = addr.code.length;
        if (codeSize > 0) {
            return Request(payable(addr));
        }
        ret = Request(
            payable(
                new ERC1967Proxy{salt: bytes32(salt)}(
                    address(requestImplementation),
                    abi.encodeCall(
                        Request.initialize,
                        (requestType, ipfsHash, payer, payee, asset, amount)
                    )
                )
            )
        );
        emit RequestDeployed(
            address(ret),
            requestType,
            ipfsHash,
            payer,
            payee,
            amount
        );
    }

    // Description: Computes the address of a new document
    // requestType: "bill", "invoice", "receipt", "refund" etc.
    // ipfsHash: IPFS hash of the request
    // payer: address of the payer
    // payee: address of the payee
    // asset: address of the asset
    // amount: amount of the asset
    // salt: salt for the address computation
    function getAddress(
        string memory requestType,
        string memory ipfsHash,
        address payer,
        address payee,
        address asset,
        uint256 amount,
        uint256 salt
    ) public view returns (address) {
        return
            Create2.computeAddress(
                bytes32(salt),
                keccak256(
                    abi.encodePacked(
                        type(ERC1967Proxy).creationCode,
                        abi.encode(
                            address(requestImplementation),
                            abi.encodeCall(
                                Request.initialize,
                                (
                                    requestType,
                                    ipfsHash,
                                    payer,
                                    payee,
                                    asset,
                                    amount
                                )
                            )
                        )
                    )
                )
            );
    }
}
