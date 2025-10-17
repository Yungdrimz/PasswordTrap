// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/**
 * @title MockKeyContract
 * @notice Simple onchain key storage contract for testing PasswordTrap.
 *         Anyone can update the key to simulate password entry attempts.
 */
contract MockKeyContract {
    string private currentKey;
    address public owner;

    event KeyUpdated(address indexed sender, string newKey);

    constructor() {
        owner = msg.sender;
        currentKey = "";
    }

    /**
     * @notice Returns the currently stored key string.
     */
    function getKey() external view returns (string memory) {
        return currentKey;
    }

    /**
     * @notice Allows anyone to update the key value (for simulation).
     * @param newKey The new key string to set.
     */
    function setKey(string calldata newKey) external {
        currentKey = newKey;
        emit KeyUpdated(msg.sender, newKey);
    }
}
