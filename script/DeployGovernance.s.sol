// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {GoerliParams} from "@script/GoerliParams.s.sol";
import {MainnetParams} from "@script/MainnetParams.s.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";

abstract contract DeployGovernance is Script {
    uint256 internal _deployerPk;
    // --- Helpers ---
    uint256 public chainId;
    address public deployer;

    function run() public {
        deployer = vm.addr(_deployerPk);
        vm.startBroadcast(deployer);

        TimeLockController timelock = new TimelockController(
            TIMELOCK_MIN_DELAY,
            new address[](0),
            new address[](0)
        );

        Governor governor = new Governor(
            GOVERNOR_NAME,
            VOTING_DELAY,
            VOTING_PERIOD,
            PROPOSAL_THRESHOLD,
            IVotes(PROTOCOL_TOKEN),
            timelock
        );

    }
}

contract DeployGovernanceGoerli is GoerliParams, DeployGovernance {
    function setup() public virtual {
        _deployerPk = uint256(vm.envBytes32("OP_GOERLI_DEPLOYER_PK"));
        chainId = 10;
    }
}

contract DeployGovernanceMainnet is MainnetParams, DeployGovernance {
    function setup() public virtual {
        _deployerPk = uint256(vm.envBytes32("OP_MAINNET_DEPLOYER_PK"));
        chainId = 420;
    }
}
