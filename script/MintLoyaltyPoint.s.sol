// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {ILoyaltyPoint} from "../src/interface/ILoyaltyPoint.sol";

contract MintLoyaltyPoint is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address loyaltyPointAddress = vm.envAddress("LOYALTY_POINT_ADDRESS");
        address userAddress = vm.envAddress("USER_ADDRESS");

        ILoyaltyPoint loyaltyPoint = ILoyaltyPoint(loyaltyPointAddress);

        vm.startBroadcast(deployerPrivateKey);

        loyaltyPoint.mint(userAddress, 1);

        vm.stopBroadcast();
    }
}
