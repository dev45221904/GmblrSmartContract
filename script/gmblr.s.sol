// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Gmblr} from "../src/gmblr.sol";

contract Deploy is Script {
    function run() external returns (Gmblr) {
        uint256 subscriptionId = vm.envUint("SUB_ID");

        vm.startBroadcast();
        Gmblr gmblr = new Gmblr(subscriptionId);
        vm.stopBroadcast();

        return gmblr;
    }
}