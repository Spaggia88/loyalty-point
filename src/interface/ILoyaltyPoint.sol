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

/**
 * @title ILoyaltyPoint
 * @author Galxe
 *
 * Interface for operating with LoyaltyPoint.
 */
interface ILoyaltyPoint {
  function mint(address user, uint256 amount) external;
  function mintBatch(address[] calldata users, uint256[] calldata amounts) external;
  function burn(address user, uint256 amount) external;
  function burnBatch(address[] calldata users, uint256[] calldata amounts) external;
  function grantRole(bytes32 role, address account) external;
  function revokeRole(bytes32 role, address account) external;
  function pause() external;
  function unpause() external;
  function setName(string calldata name) external;
  function setSymbol(string calldata symbol) external;
  function setTransferable(bool allow) external;
  function beginDefaultAdminTransfer(address newAdmin) external;
  function cancelDefaultAdminTransfer() external;
  function acceptDefaultAdminTransfer() external;
}
