// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {V2PairHook} from "../src/V2PairHook.sol";
import {UniswapV2PairHookFactory} from "../src/UniswapV2PairHookFactory.sol";
import {Script} from "forge-std/Script.sol";
import {AddLiquidityRouter} from "../test/mocks/AddLiquidityRouter.sol";
import {PoolManager} from "@uniswap/v4-core/src/PoolManager.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {HelperScript} from "./Helper.s.sol";
contract DeployScript is HelperScript {
    PoolManager manager;
    UniswapV2PairHookFactory factory;
    AddLiquidityRouter liquidityRouter;

    MockERC20 token0;
    MockERC20 token1;


    function run() public broadcast{
         manager = new PoolManager(500000);
         factory = new UniswapV2PairHookFactory(manager);
         token0 = new MockERC20("Token0", "T0", 18);
         token1 = new MockERC20("Token1", "T1", 18);
         IHooks hook = factory.createHook("azt", address(token0), address(token1));
    }
}
