// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {IERC20Metadata} from '@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import {IVotes, IERC20Permit} from '@openzeppelin/token/ERC20/extensions/ERC20Votes.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';

interface IProtocolToken is IVotes, IERC20Metadata, IERC20Permit, IAuthorizable {
  /**
   * @notice Mint an amount of tokens to an account
   * @param _account Address of the account to mint tokens to
   * @param _amount Amount of tokens to mint [wad]
   * @dev   Only authorized addresses can mint tokens
   */
  function mint(address _account, uint256 _amount) external;

  /**
   * @notice Burn an amount of tokens from the sender
   * @param _amount Amount of tokens to burn [wad]
   */
  function burn(uint256 _amount) external;
}
