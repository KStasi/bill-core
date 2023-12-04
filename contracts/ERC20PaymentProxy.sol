// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20PaymentProxy {
    event TransferWithReferenceExecuted(
        address tokenAddress,
        address indexed from,
        address indexed to,
        uint256 value,
        address indexed referenceId
    );

    receive() external payable {
        revert("The contract is not payable");
    }

    // Description: Transfers ERC20 to the specified address
    // tokenAddress: address of the ERC20 token
    // to: address of the recipient
    // value: amount of ERC20 to transfer
    // referenceId: address of the request
    function transferWithReference(
        address tokenAddress,
        address to,
        uint256 value,
        address referenceId
    ) external {
        ERC20 erc20 = ERC20(tokenAddress);
        require(
            erc20.transferFrom(msg.sender, to, value),
            "TransferFrom has failed"
        );
        emit TransferWithReferenceExecuted(
            tokenAddress,
            msg.sender,
            to,
            value,
            referenceId
        );
    }
}
