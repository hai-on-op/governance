// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Common} from '@script/Common.s.sol';
import {MainnetParams} from '@script/MainnetParams.s.sol';
// import {Params} from '@script/Params.s.sol';

/**
 * @title  MainnetScript
 * @notice This contract is used to deploy the system on Mainnet
 * @dev    This contract imports deployed addresses from `MainnetDeployment.s.sol`
 */
contract MainnetScript is MainnetParams, Common, Script {
    function setUp() public virtual {
        chainId = 10;
    }

    /**
     * @notice This script is left as an example on how to use MainnetScript contract
     * @dev    This script is executed with `yarn script:mainnet` command
     */
    function run() public {
        _getEnvironmentParams();
        vm.startBroadcast();

        // Script goes here
        console.log("Hello world Mainnet!");

        vm.stopBroadcast();
    }
}
