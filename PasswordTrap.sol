// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Trap} from "lib/contracts/src/Trap.sol";

interface IKeyContract {
    function getKey() external view returns (string memory);
}

/**
 * @title PasswordTrap
 * @notice Watches a KeyContract and triggers when its stored key matches a preset password.
 * @dev Drosera-compatible trap: no constructor args, pure/view only, deterministic behavior.
 */
contract PasswordTrap is Trap {
    address public keyContract;
    bytes32 public targetHash;

    constructor() {
        keyContract = address(0);
        targetHash = keccak256(abi.encodePacked("open-sesame"));
    }

    function setKeyContract(address _keyContract) external {
        keyContract = _keyContract;
    }

    function setTargetHash(string memory password) external {
        targetHash = keccak256(abi.encodePacked(password));
    }

    /**
     * @notice Collects the password string from the linked KeyContract.
     * @dev Returns the raw bytes of the string for Drosera processing.
     */
    function collect() external view override returns (bytes memory) {
        if (keyContract == address(0)) return abi.encode("");
        string memory current = IKeyContract(keyContract).getKey();
        return bytes(current);
    }

    /**
     * @notice Compares the collected key against the target hash.
     * @dev Must be pure (no storage reads).
     */
    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        if (data.length == 0) return (false, bytes(""));

        string memory attempt = string(data[0]);
        bytes32 attemptHash = keccak256(abi.encodePacked(attempt));
        bytes32 correctHash = keccak256(abi.encodePacked("open-sesame"));

        if (attemptHash == correctHash) {
            return (true, abi.encode(attempt));
        }

        return (false, bytes(""));
    }
}
