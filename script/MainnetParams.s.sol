// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {Params} from "@script/Params.s.sol";

abstract contract MainnetParams is Params {
    // --- Mainnet Params ---
    function _getEnvironmentParams() internal override {
        timelockMinDelay = 86400; // 1 day
        protocolToken = 0x0000000000000000000000000000000000000000;
        votingDelay = 3600; // 12 hours
        votingPeriod = 10800; // 36 hours
        proposalThreshold = 5000e18; // 5k
    }
}
