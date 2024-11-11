// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {LoyaltyPoint} from "../../src/LoyaltyPoint/LoyaltyPoint.sol";

contract AddHook is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address loyaltyPointAddress = vm.envAddress("LOYALTY_POINT_ADDRESS");
        address hookAddress = vm.envAddress("HOOK_ADDRESS");

        console.log("Adding hook", hookAddress, "to", loyaltyPointAddress);

        LoyaltyPoint loyaltyPoint = LoyaltyPoint(loyaltyPointAddress);

        vm.startBroadcast(deployerPrivateKey);

        // Create a low-level call to the factory contract
        (bool success, bytes memory result) =
            address(loyaltyPoint).call(abi.encodeWithSignature("addHook(address)", hookAddress));

        vm.stopBroadcast();

        if (!success) {
            revert("Failed to add hook");
        }

        console.log("Hook added successfully");
        console.logBytes(result);
    }
}
