# stakingcontract

Description:

The provided code represents a Solidity smart contract named "ERC20Staking" designed for staking a specific ERC-20 token. This contract allows users to deposit, withdraw, and compound their staked tokens to earn rewards. The code also contains test cases for various contract functions. Here's a breakdown of the key components and functionality:

1. **Pragma and Imports:**
   - The contract starts with a SPDX license identifier and specifies the Solidity compiler version (0.8.9).
   - It imports the SafeERC20 library from the OpenZeppelin contracts, which provides safe operations for ERC-20 tokens.

2. **Contract State Variables:**
   - `token`: An immutable state variable representing the ERC-20 token that users can stake.
   - `rewardsPerHour`: An immutable state variable representing the reward rate in tokens per hour.
   - `totalStaked`: A state variable that keeps track of the total amount of tokens staked.

3. **Constructor:**
   - The constructor takes an ERC-20 token as a parameter and initializes the `token` variable.

4. **Staking Functions:**
   - `deposit(uint amount_)`: Allows users to stake a specified amount of tokens. The tokens are transferred from the user's address to the contract, and the user's balance is updated.
   - `withdraw(uint amount_)`: Allows users to withdraw a specified amount of tokens from their stake. If the withdrawal amount exceeds the user's balance, it reverts.
   - `compound()`: Compounds the rewards, effectively reinvesting them, which increases the user's balance, the total staked amount, and updates the last claim time.

5. **View Functions:**
   - `totalRewards()`: Calculates the total rewards available in the contract.
   - `rewards(address address_)`: Calculates the rewards for a specific user.

6. **Internal Functions:**
   - `_totalRewards()`: An internal function to calculate the total rewards.
   - `_rewards(address address_)`: An internal function to calculate the rewards for a specific user.

7. **Event Definitions:**
   - `Deposit(address address_, uint amount_)`: An event emitted when a user makes a deposit.
   - `Withdraw(address address_, uint amount_)`: An event emitted when a user withdraws tokens.
   - `Claim(address address_, uint amount_)`: An event emitted when a user claims rewards.
   - `Compound(address address_, uint amount_)`: An event emitted when a user compounds their rewards.

8. **Test Cases:**
   - The code includes a series of test cases using JavaScript testing libraries (e.g., `expect`). These test cases cover various scenarios for depositing, withdrawing, and compounding rewards, as well as checking the contract's state and event emissions during these actions.

Overall, the ERC20Staking contract allows users to stake tokens and earn rewards over time. The provided test cases help ensure that the contract functions correctly and that events are emitted as expected during user interactions.
