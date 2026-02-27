// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Intentionally vulnerable contract for ClawAudit PR webhook testing.
 * Reentrancy: withdraw() sends ETH before updating balances.
 */
contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");
        // VULNERABILITY: external call before state update allows reentrancy
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        balances[msg.sender] = 0;
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
