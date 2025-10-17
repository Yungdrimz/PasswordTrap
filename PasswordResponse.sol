// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/**
 * @title PasswordResponse
 * @notice Executes an action when the PasswordTrap condition is met.
 * @dev Minimal standalone response contract compatible with Drosera.
 */
contract PasswordResponse {
    event PasswordMatched(address indexed triggeredBy, string matchedValue);

    /**
     * @notice Called automatically by Drosera when a trap triggers.
     * @param data Encoded string value from PasswordTrap.
     */
    function respond(bytes calldata data) external {
        string memory matchedValue = abi.decode(data, (string));
        emit PasswordMatched(msg.sender, matchedValue);
        // Add your onchain logic here (e.g., unlock access, transfer tokens, etc.)
    }
}
