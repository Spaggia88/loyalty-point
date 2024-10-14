// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/examples/ExampleLoyaltyPointHook.sol";

contract DeployExampleLoyaltyPointHook is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        console.log("Deploying ExampleLoyaltyPointHook...");

        vm.startBroadcast(deployerPrivateKey);

        ExampleLoyaltyPointHook hook = new ExampleLoyaltyPointHook();

        console.log("ExampleLoyaltyPointHook deployed at:", address(hook));

        vm.stopBroadcast();
    }
}
