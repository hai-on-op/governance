// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

abstract contract Params {
    string constant GOVERNOR_NAME = "TestGovernor3";
    uint256 timelockMinDelay;
    address protocolToken;
    uint48 votingDelay;
    uint32 votingPeriod;
    uint256 proposalThreshold;

    function _getEnvironmentParams() internal virtual;
}
