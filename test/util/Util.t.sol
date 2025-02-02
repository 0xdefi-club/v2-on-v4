// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {UtilScript} from "../../script/Util.s.sol";

contract UtilTest is Test {
    UtilScript util;

    function setUp() public {
        util = new UtilScript();
    }

    function test_calculate_flags() public {
        Hooks.Permissions memory permissions = Hooks.Permissions({
            beforeInitialize: true,
            afterInitialize: false,
            beforeAddLiquidity: true,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: true,
            afterRemoveLiquidity: false,
            beforeSwap: true,
            afterSwap: false,
            beforeDonate: true,
            afterDonate: false,
            beforeSwapReturnDelta: true,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: true,
            afterRemoveLiquidityReturnDelta: false
        });

        uint256 flags = util.calculateFlags(permissions);
        assertTrue(flags != 0, "Flags should not be zero");
        
        assertTrue(flags & Hooks.BEFORE_INITIALIZE_FLAG != 0, "BEFORE_INITIALIZE_FLAG should be set");
        assertTrue(flags & Hooks.AFTER_INITIALIZE_FLAG == 0, "AFTER_INITIALIZE_FLAG should not be set");
    }

    function test_calculate_required_address() public {
        Hooks.Permissions memory permissions = Hooks.Permissions({
            beforeInitialize: true,
            afterInitialize: false,
            beforeAddLiquidity: true,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: true,
            afterRemoveLiquidity: false,
            beforeSwap: true,
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: true,
            afterSwapReturnDelta: true,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });

        address requiredAddress = util.calculateRequiredAddress(permissions);
        assertTrue(requiredAddress == address(0xaB30000000000000000000000000000000000000), "0xab3 should be the required address");
    }
}
