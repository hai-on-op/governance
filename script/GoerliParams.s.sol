// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Params} from "@script/Params.s.sol";

abstract contract GoerliParams is Params {
    // --- Testnet Params ---
    function _getEnvironmentParams() internal override {
        // timelockMinDelay = 3600; // 1 hour
        // protocolToken = 0xbcc847DdE48E579fa8d98E0d4bd46161A0f84F8A;
        // votingDelay = 25; // 5 minutes
        // votingPeriod = 100; // 20 minutes
        // proposalThreshold = 460000e18; // 460k
    }
}
