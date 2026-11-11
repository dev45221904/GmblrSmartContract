// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.35;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {Deploy} from "../script/gmblr.s.sol";
import {Gmblr} from "../src/gmblr.sol";

contract test is Test{
    Gmblr gmblr;

    function setUp() external{
        Deploy deploy = new Deploy();
        gmblr = deploy.run();
    }

    function testpricheck() public view{
        assertEq(gmblr.price(), 1e15);
    }
    
    function 
}