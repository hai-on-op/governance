// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Params} from "@script/Params.s.sol";
import {GoerliParams} from "@script/GoerliParams.s.sol";
import {MainnetParams} from "@script/MainnetParams.s.sol";
import {TimelockController} from "@openzeppelin/governance/TimelockController.sol";
import {HaiGovernor} from "@governance/HaiGovernor.sol";
import {IVotes} from "@openzeppelin/governance/utils/IVotes.sol";

abstract contract DeployGovernance is Script, Params {
    uint256 internal _deployerPk;
    // --- Helpers ---
    uint256 public chainId;
    address public deployer;

    function run() public {
        _getEnvironmentParams();

        deployer = vm.addr(_deployerPk);
        vm.startBroadcast(deployer);

        TimelockController timelock = new TimelockController(
            timelockMinDelay,
            new address[](0),
            new address[](0),
            address(0)
        );

        new HaiGovernor(
            GOVERNOR_NAME,
            votingDelay,
            votingPeriod,
            proposalThreshold,
            IVotes(protocolToken),
            timelock
        );
    }
}

contract DeployGovernanceGoerli is GoerliParams, DeployGovernance {
    function setUp() public virtual {
        _deployerPk = uint256(vm.envBytes32("OP_GOERLI_DEPLOYER_PK"));
        chainId = 420;
    }
}

contract DeployGovernanceMainnet is MainnetParams, DeployGovernance {
    function setUp() public virtual {
        _deployerPk = uint256(vm.envBytes32("OP_MAINNET_DEPLOYER_PK"));
        chainId = 10;
    }
}
