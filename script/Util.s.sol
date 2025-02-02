// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {VmSafe} from "forge-std/Vm.sol";
import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";


contract UtilScript is Script {
   function calculateFlags(Hooks.Permissions memory permissions) public pure returns (uint256) {
        uint256 flags;
        
        if (permissions.beforeInitialize) flags |= Hooks.BEFORE_INITIALIZE_FLAG;
        if (permissions.afterInitialize) flags |= Hooks.AFTER_INITIALIZE_FLAG;
        if (permissions.beforeAddLiquidity) flags |= Hooks.BEFORE_ADD_LIQUIDITY_FLAG;
        if (permissions.afterAddLiquidity) flags |= Hooks.AFTER_ADD_LIQUIDITY_FLAG;
        if (permissions.beforeRemoveLiquidity) flags |= Hooks.BEFORE_REMOVE_LIQUIDITY_FLAG;
        if (permissions.afterRemoveLiquidity) flags |= Hooks.AFTER_REMOVE_LIQUIDITY_FLAG;
        if (permissions.beforeSwap) flags |= Hooks.BEFORE_SWAP_FLAG;
        if (permissions.afterSwap) flags |= Hooks.AFTER_SWAP_FLAG;
        if (permissions.beforeDonate) flags |= Hooks.BEFORE_DONATE_FLAG;
        if (permissions.afterDonate) flags |= Hooks.AFTER_DONATE_FLAG;
        if (permissions.beforeSwapReturnDelta) flags |= Hooks.BEFORE_SWAP_RETURNS_DELTA_FLAG;
        if (permissions.afterSwapReturnDelta) flags |= Hooks.AFTER_SWAP_RETURNS_DELTA_FLAG;
        if (permissions.afterAddLiquidityReturnDelta) flags |= Hooks.AFTER_ADD_LIQUIDITY_RETURNS_DELTA_FLAG;
        if (permissions.afterRemoveLiquidityReturnDelta) flags |= Hooks.AFTER_REMOVE_LIQUIDITY_RETURNS_DELTA_FLAG;
        
        return flags;
    }

    function calculateRequiredAddress(Hooks.Permissions memory permissions) public pure returns (address) {
        uint256 flags = calculateFlags(permissions);
        // Clear all but the first 20 bytes to get the required address prefix
        return address(uint160(flags));
    }
}