// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

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
