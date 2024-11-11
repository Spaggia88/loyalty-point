// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {BaseScript} from "../utils/Base.s.sol";
import {LoyaltyPointFactory} from "../../src/LoyaltyPoint/LoyaltyPointFactory.sol";

contract DeployLoyaltyPointFactory is BaseScript {
    string internal constant KEY = "LOYALTY_POINT_FACTORY";

    function run() external chain broadcaster {
        bytes32 CREATE2_SALT = vm.envBytes32("CREATE2_SALT");
        address OWNER = vm.envAddress("OWNER");

        console.log("Deploying LoyaltyPointFactory with owner", OWNER);

        LoyaltyPointFactory factory = new LoyaltyPointFactory{salt: CREATE2_SALT}(OWNER);

        console.log("LoyaltyPointFactory deployed at:", address(factory));

        // Write address
        writeAddress(KEY, address(factory));
    }
}
