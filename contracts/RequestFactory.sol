// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "./Request.sol";

contract RequestFactory {
    Request public immutable requestImplementation;

    event RequestDeployed(address indexed newRequest);

    constructor(address _storageManager) {
        requestImplementation = new Request(_storageManager);
    }

    function createRequest(
        string memory requestType,
        string memory ipfsHash,
        address payer,
        address payee,
        uint256 amount,
        uint256 salt
    ) public returns (Request ret) {
        address addr = getAddress(
            requestType,
            ipfsHash,
            payer,
            payee,
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
                        (requestType, ipfsHash, payer, payee, amount)
                    )
                )
            )
        );
        emit RequestDeployed(address(ret));
    }

    function getAddress(
        string memory requestType,
        string memory ipfsHash,
        address payer,
        address payee,
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
                                (requestType, ipfsHash, payer, payee, amount)
                            )
                        )
                    )
                )
            );
    }
}
