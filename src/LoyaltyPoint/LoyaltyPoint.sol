// SPDX-License-Identifier: Apache-2.0

/*
     Copyright 2024 Galxe.

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
 */
pragma solidity ^0.8.24;

import {
  AccessControlDefaultAdminRules
} from "@openzeppelin/contracts/access/extensions/AccessControlDefaultAdminRules.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ERC20Pausable } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import { ERC20Permit } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import { ILoyaltyPointHook } from "../interface/ILoyaltyPointHook.sol";

/// @title Galxe LoyaltyPoint Contract
/// @author Galxe Team
/// @notice This contract is used to create a loyalty point for a space.
/// @custom:security-contact security@galxe.com
contract LoyaltyPoint is ERC20, ERC20Permit, ERC20Pausable, AccessControlDefaultAdminRules {
  error InvalidAddress();
  error TransferNotAllow();
  error ParamsLengthMismatch();
  error PermissionDenied();
  error SetTransferableNotAllowed();
  error HookExecutionFailed();
  error IndexOutOfRange();

  modifier whenTransferable() {
    if (!transferable()) {
      revert TransferNotAllow();
    }
    _;
  }

  string private _name;
  string private _symbol;
  bool private _transferable;
  ILoyaltyPointHook[] private _hooks;

  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

  constructor(
    string memory name_,
    string memory symbol_,
    address initialAdmin_,
    address[] memory minters_
  ) ERC20(name_, symbol_) ERC20Permit(name_) AccessControlDefaultAdminRules(0, initialAdmin_) {
    _transferable = false;
    _name = super.name();
    _symbol = super.symbol();
    if (initialAdmin_ == address(0)) {
      revert InvalidAddress();
    }
    for (uint256 i = 0; i < minters_.length; i++) {
      if (minters_[i] == address(0)) {
        revert InvalidAddress();
      }
    }
    for (uint256 i = 0; i < minters_.length; i++) {
      _grantRole(MINTER_ROLE, minters_[i]);
    }
  }

  /// @notice Pauses the contract.
  function pause() public onlyRole(DEFAULT_ADMIN_ROLE) {
    _pause();
  }

  /// @notice Unpauses the contract.
  function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) {
    _unpause();
  }
  /// @notice Returns the name of the token.
  /// @dev This is a custom function that overrides the OpenZeppelin function.
  function name() public view override returns (string memory) {
    return _name;
  }

  /// @notice Sets the name of the token.
  /// @dev This gives the owner the ability to change the name of the token.
  function setName(string calldata newName) public whenNotPaused onlyRole(DEFAULT_ADMIN_ROLE) {
    _name = newName;
  }

  /// @notice Returns the symbol of the token.
  /// @dev This is a custom function that overrides the OpenZeppelin function.
  function symbol() public view override returns (string memory) {
    return _symbol;
  }

  /// @notice Sets the symbol of the token.
  /// @dev This gives the owner the ability to change the name of the token.
  function setSymbol(string calldata newSymbol) public whenNotPaused onlyRole(DEFAULT_ADMIN_ROLE) {
    _symbol = newSymbol;
  }

  /// @notice Returns the transferable status of the token.
  function transferable() public view returns (bool) {
    return _transferable;
  }

  /// @notice Sets the transferable status of the token.
  /// @dev This gives the owner or space manager the ability to change the transferable status of the token.
  function setTransferable(bool newTransferable) public whenNotPaused onlyRole(DEFAULT_ADMIN_ROLE) {
    _transferable = newTransferable;
  }

  /// @notice Adds a hook to the contract
  /// @param hook The hook to be added
  function addHook(ILoyaltyPointHook hook) public onlyRole(DEFAULT_ADMIN_ROLE) {
    if (address(hook) == address(0)) {
      revert InvalidAddress();
    }
    _hooks.push(hook);
  }

  /// @notice Deletes a hook from the contract
  function deleteHook(uint256 index) public onlyRole(DEFAULT_ADMIN_ROLE) {
    if (index >= _hooks.length) {
      revert IndexOutOfRange();
    }
    delete _hooks[index];
  }

  /// @notice Returns the hooks of the contract
  function getHooks() public view returns (ILoyaltyPointHook[] memory) {
    return _hooks;
  }

  /// @notice Mints point for a user by minter
  /// @param _user The address of the user who needs point minted
  /// @param _amount The amount of points being minted
  function mint(address _user, uint256 _amount) public whenNotPaused onlyRole(MINTER_ROLE) {
    if (_user == address(0)) {
      revert InvalidAddress();
    }
    _mint(_user, _amount);
  }

  /// @notice Mints points for multiple users by minter
  /// @param _users The addresses of the users who need points minted
  /// @param _amounts The amount of points being minted
  function mintBatch(
    address[] calldata _users,
    uint256[] calldata _amounts
  ) public whenNotPaused onlyRole(MINTER_ROLE) {
    if (_users.length != _amounts.length) {
      revert ParamsLengthMismatch();
    }
    for (uint256 i = 0; i < _users.length; i++) {
      if (_users[i] == address(0)) {
        revert InvalidAddress();
      }
    }
    for (uint256 i = 0; i < _users.length; i++) {
      _mint(_users[i], _amounts[i]);
    }
  }

  /// @notice Burns point for a user by minter
  /// @param _user The address of the user who needs point burned
  /// @param _amount The amount of points being burned
  function burn(address _user, uint256 _amount) public whenNotPaused onlyRole(MINTER_ROLE) {
    if (_user == address(0)) {
      revert InvalidAddress();
    }
    _burn(_user, _amount);
  }

  /// @notice Burns points for multiple users by minter
  /// @param _users The addresses of the users who need points burned
  /// @param _amounts The amounts of points being burned
  function burnBatch(
    address[] calldata _users,
    uint256[] calldata _amounts
  ) public whenNotPaused onlyRole(MINTER_ROLE) {
    if (_users.length != _amounts.length) {
      revert ParamsLengthMismatch();
    }
    for (uint256 i = 0; i < _users.length; i++) {
      if (_users[i] == address(0)) {
        revert InvalidAddress();
      }
    }
    for (uint256 i = 0; i < _users.length; i++) {
      _burn(_users[i], _amounts[i]);
    }
  }

  /// @notice Transfers tokens from one account to another
  function transfer(address to, uint256 value) public override whenNotPaused whenTransferable returns (bool) {
    return super.transfer(to, value);
  }

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) public override whenNotPaused whenTransferable returns (bool) {
    return super.transferFrom(from, to, value);
  }

  // Overrides required by Solidity.
  function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) {
    for (uint256 i = 0; i < _hooks.length; i++) {
      if (address(_hooks[i]) != address(0) && !_hooks[i].onUpdate(from, to, value)) {
        revert HookExecutionFailed();
      }
    }
    super._update(from, to, value);
  }
}
