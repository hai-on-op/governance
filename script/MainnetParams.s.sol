// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@script/Params.s.sol';

abstract contract MainnetParams is Params {
    // --- Mainnet Params ---
    uint256 constant TIMELOCK_MIN_DELAY = 86400; // 1 day
    address constant PROTOCOL_TOKEN = 0x0000000000000000000000000000000000000000;
    uint48 constant VOTING_DELAY = 3600;  // 12 hours
    uint32 constant VOTING_PERIOD = 10800; // 36 hours
    uint256 constant PROPOSAL_THRESHOLD = 5000e18; // 5k
}