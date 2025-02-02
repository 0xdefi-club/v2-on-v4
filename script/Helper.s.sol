// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {VmSafe} from "forge-std/Vm.sol";


abstract contract HelperScript is Script {
    address deployer;

    modifier broadcast() {
        vm.startBroadcast(deployer);
        _;
        vm.stopBroadcast();
    }
    
    // TODO: load config etc.
    function setUp() public virtual {
        uint256 privateKey = vm.envUint(string.concat("PRIVATE_KEY_", vm.toString(block.chainid)));
        deployer = vm.addr(privateKey);
    }
}
