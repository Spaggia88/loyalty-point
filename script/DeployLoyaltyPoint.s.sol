// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";

contract DeployLoyaltyPoint is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");
        address owner = vm.envAddress("OWNER");
        address minter = vm.envAddress("MINTER");

        console.log(
            "Deploying LoyaltyPoint via factory",
            factoryAddress,
            "with owner",
            owner
        );

        vm.startBroadcast(deployerPrivateKey);

        string memory name = "My Loyalty Point";
        string memory symbol = "MLP";
        address initialAdmin = owner;
        address[] memory minters = new address[](1);
        minters[0] = minter;

        // Create a low-level call to the factory contract
        (bool success, bytes memory result) = factoryAddress.call(
            abi.encodeWithSignature(
                "createLoyaltyPoint(string,string,address,address[])",
                name,
                symbol,
                initialAdmin,
                minters
            )
        );

        if (!success) {
            revert("Factory call failed");
        }
        address loyaltyPointAddress = abi.decode(result, (address));
        console.log("LoyaltyPoint deployed at:", loyaltyPointAddress);

        vm.stopBroadcast();
    }
}
