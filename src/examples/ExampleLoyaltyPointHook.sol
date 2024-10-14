// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../interface/ILoyaltyPointHook.sol"; // Adjust the path as necessary

contract ExampleLoyaltyPointHook is ILoyaltyPointHook {
    // Event emitted when points are updated
    event PointsUpdated(
        address indexed from,
        address indexed to,
        uint256 value
    );

    // Implementing the onUpdate function
    function onUpdate(
        address from,
        address to,
        uint256 value
    ) external override returns (bool) {
        // Emit the PointsUpdated event
        emit PointsUpdated(from, to, value);
        return true; // Indicate success
    }
}
