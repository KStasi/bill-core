// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NativePaymentProxy {
    event TransferWithReferenceExecuted(
        address indexed from,
        address indexed to,
        uint256 value,
        address indexed referenceId
    );

    receive() external payable {
        revert("The contract is not payable");
    }

    // Description: Transfers ETH to the specified address
    // to: address of the recipient
    // value: amount of ETH to transfer
    // referenceId: address of the request
    function transferWithReference(
        address to,
        uint256 value,
        address referenceId
    ) external payable {
        (bool success, ) = to.call{value: msg.value}("");
        require(success, "Transfer has failed");
        emit TransferWithReferenceExecuted(msg.sender, to, value, referenceId);
    }
}
