## Gravity Alpha Testnet Sepolia

### Deploy

1. Deploy LoyaltyPointFactory

   ```
   forge create --rpc-url https://rpc-sepolia.gravity.xyz --constructor-args 0xa272C14931E725D5cDB30f87Af77CF5Ce3d20B32 --private-key <omit> --etherscan-api-key 123 --verify src/LoyaltyPoint/LoyaltyPointFactory.sol:LoyaltyPointFactory
   ```

2. Deploy LoyaltyPoint

   ```
   FACTORY_ADDRESS=0x8a85eC5AE1ae2c757eEfBb10b1203C984120bf8c PRIVATE_KEY=<omitted> OWNER=0xa272C14931E725D5cDB30f87Af77CF5Ce3d20B32 MINTER=0xa272C14931E725D5cDB30f87Af77CF5Ce3d20B32 forge script script/DeployLoyaltyPoint.s.sol:DeployLoyaltyPoint --rpc-url https://rpc-sepolia.gravity.xyz --gas-estimate-multiplier 200
   ```

3. Deploy ExampleLoyaltyPointHook

   ```
   PRIVATE_KEY=<omitted> forge script script/DeployExampleLoyaltyPointHook.s.sol:DeployExampleLoyaltyPointHook --rpc-url https://rpc-sepolia.gravity.xyz --broadcast --gas-estimate-multiplier 10000
   ```

4. Add Hook

   ```
   PRIVATE_KEY=<omitted> LOYALTY_POINT_ADDRESS=0xdffac9197c2e2505600529687c889920c4054e4a HOOK_ADDRESS=0xf385b659DD1B6785d4FDf83E34Ee228d2Fb10281 forge script script/AddHook.s.sol:AddHook --rpc-url https://rpc-sepolia.gravity.xyz --broadcast --gas-estimate-multiplier 5000
   ```

5. Mint Loyalty Point to user

   ```
   PRIVATE_KEY=<omitted> LOYALTY_POINT_ADDRESS=0xdffac9197c2e2505600529687c889920c4054e4a USER_ADDRESS=0xa272C14931E725D5cDB30f87Af77CF5Ce3d20B32 forge script script/MintLoyaltyPoint.s.sol:MintLoyaltyPoint --rpc-url https://rpc-sepolia.gravity.xyz --gas-estimate-multiplier 5000 --broadcast
   ```

   tx: [0xa4d01f742a1f532cecdb3b0c0a1a3b0922603cec4cf0edf46bd00c549ad03b75](https://explorer-sepolia.gravity.xyz/tx/0xa4d01f742a1f532cecdb3b0c0a1a3b0922603cec4cf0edf46bd00c549ad03b75)

   In logs, you can see that the hook is called and the `PointsUpdated` event is emitted.

### Contract Addresses

#### LoyaltyPointFactory

- Contract: https://explorer-sepolia.gravity.xyz/address/0x8a85eC5AE1ae2c757eEfBb10b1203C984120bf8c
- Verification: `forge verify-contract --chain-id 13505 --watch --constructor-args $(cast abi-encode "constructor(address)" "0xa272C14931E725D5cDB30f87Af77CF5Ce3d20B32") --etherscan-api-key 123 --compiler-version 0.8.26+commit.8a97fa7a 0x8a85eC5AE1ae2c757eEfBb10b1203C984120bf8c src/LoyaltyPoint/LoyaltyPointFactory.sol:LoyaltyPointFactory`

#### LoyaltyPoint

- Contract: https://explorer-sepolia.gravity.xyz/address/0xdffac9197c2e2505600529687c889920c4054e4a
- Verification: `forge verify-contract --chain-id 13505 --watch --constructor-args $(cast abi-encode "constructor(string,string,address,address[])" "My Loyalty Point" "MLP" "0xa272C14931E725D5cDB30f87Af77CF5Ce3d20B32" "[0xa272C14931E725D5cDB30f87Af77CF5Ce3d20B32]") --etherscan-api-key 123 --compiler-version 0.8.26+commit.8a97fa7a 0xdffac9197c2e2505600529687c889920c4054e4a src/LoyaltyPoint/LoyaltyPoint.sol:LoyaltyPoint`

#### ExampleLoyaltyPointHook

- Contract: https://explorer-sepolia.gravity.xyz/address/0xf385b659DD1B6785d4FDf83E34Ee228d2Fb10281
- Verification: `forge verify-contract --chain-id 13505 --watch --etherscan-api-key 123 --compiler-version 0.8.26+commit.8a97fa7a 0xf385b659DD1B6785d4FDf83E34Ee228d2Fb10281 src/examples/ExampleLoyaltyPointHook.sol:ExampleLoyaltyPointHook`
