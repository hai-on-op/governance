// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {Params} from "@script/Params.s.sol";

abstract contract MainnetParams is Params {
    // --- Mainnet Params ---
    function _getEnvironmentParams() internal override {
        timelockMinDelay = 300; // 5 minutes
        protocolToken = 0x2F16f25ca0c16Cf28533e82Cc1CC6B1a66aFe155;
        votingDelay = 300; // 5 minutes
        votingPeriod = 300; // 5 minutes
        proposalThreshold = 5000e18; // 5k
    }
}
