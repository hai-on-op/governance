// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Script, console} from 'forge-std/Script.sol';
import {Common} from '@script/Common.s.sol';
import {GoerliParams} from '@script/GoerliParams.s.sol';


/**
 * @title  GoerliScript
 * @notice This contract is used to deploy the system on Goerli
 * @dev    This contract imports deployed addresses from `GoerliDeployment.s.sol`
 */
contract GoerliScript is GoerliParams, Common, Script {
  function setUp() public virtual {
    chainId = 420;
  }

  /**
   * @notice This script is left as an example on how to use GoerliScript contract
   * @dev    This script is executed with `yarn script:goerli` command
   */
  function run() public {
    _getEnvironmentParams();
    vm.startBroadcast();

    // Script goes here
    console.log("Hello world goerli!");

    vm.stopBroadcast();
  }
}
