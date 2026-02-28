// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Patched contract with reentrancy fix.
 */
contract PatchedBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");

        // PATCH: Update state before sending funds (Checks-Effects-Interactions pattern)
        balances[msg.sender] = 0; // Effect: Set balance to zero first

        (bool success, ) = payable(msg.sender).call{value: amount}(""); // Interaction: Then send funds
        require(success, "Transfer failed");
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}