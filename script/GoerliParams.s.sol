// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@script/Params.s.sol';

abstract contract GoerliParams is Params {
    // --- Testnet Params ---
    uint256 constant TIMELOCK_MIN_DELAY = 3600; // 1 hour
    address constant PROTOCOL_TOKEN = 0xbcc847DdE48E579fa8d98E0d4bd46161A0f84F8A;
    uint48 constant VOTING_DELAY = 25; // 5 minutes
    uint32 constant VOTING_PERIOD = 100; // 20 minutes
    uint256 constant PROPOSAL_THRESHOLD = 460000e18; // 460k
}