// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {BaseScript} from "../utils/Base.s.sol";

contract DeployLoyaltyPoint is BaseScript {
    function run() external chain broadcaster {
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");
        address owner = vm.envAddress("OWNER");
        address minter = vm.envAddress("MINTER");

        console.log("Deploying LoyaltyPoint via factory", factoryAddress, "with owner", owner);

        string memory name = "My Loyalty Point";
        string memory symbol = "MLP";
        address initialAdmin = owner;
        address[] memory minters = new address[](1);
        minters[0] = minter;

        // Create a low-level call to the factory contract
        (bool success, bytes memory result) = factoryAddress.call(
            abi.encodeWithSignature(
                "createLoyaltyPoint(string,string,address,address[])", name, symbol, initialAdmin, minters
            )
        );

        if (!success) {
            revert("Factory call failed");
        }
        address loyaltyPointAddress = abi.decode(result, (address));
        console.log("LoyaltyPoint deployed at:", loyaltyPointAddress);
    }
}
