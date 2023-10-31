// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ERC20Staking {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;
    uint public immutable rewardsPerHour = 1000; // 0.01%

    uint public totalStaked = 0;

    constructor(IERC20 token_) {
        token = token_;
    }
    
}

it("should have 0 staked", async function () {
  expect(await staking.totalStaked()).to.eq(0)
})

it("should have 80,000,000 rewards", async function () {
  expect(await staking.totalRewards()).to.eq(initialRewards)
})
function totalRewards() external view returns (uint) {
  return _totalRewards();
}

function _totalRewards() internal view returns (uint) {
  return token.balanceOf(address(this)) - totalStaked;
}
it("should have 0.01% rewards per hour", async function () {
  expect(await staking.rewardsPerHour()).to.eq(1000)
})
// ...
uint public immutable rewardsPerHour = 1000; // 0.01%
// ...
it("should transfer amount", async function () {
  await expect(staking.deposit(amount)).to.changeTokenBalances(token, 
    [signer, staking],
    [amount.mul(-1), amount]
  )
})
function deposit(uint amount_) external {
  token.safeTransferFrom(msg.sender, address(this), amount_);
}
it("should increment balance by amount", async function () {
  const balance = await staking.balanceOf(signer.address)
  await staking.deposit(amount)
  expect(await staking.balanceOf(signer.address)).to.eq(balance.add(amount))
})
// ...
mapping(address => uint) public balanceOf;
// ...
function deposit(uint amount_) external {
  token.safeTransferFrom(msg.sender, address(this), amount_);
  balanceOf[msg.sender] += amount_;
}
it("should have lastUpdated equal to the latest block timestamp", async function () {
  await staking.deposit(amount)
  const latest = await time.latest()
  expect(await staking.lastUpdated(signer.address)).to.eq(latest)
})
// ...
mapping(address => uint) public lastUpdated;
// ...
function deposit(uint amount_) external {
  token.safeTransferFrom(msg.sender, address(this), amount_);
  balanceOf[msg.sender] += amount_;
  lastUpdated[msg.sender] = block.timestamp;
}
it("should increment the total staked by amount", async function () {
  const totalStaked = await staking.totalStaked()
  await staking.deposit(amount)
  expect(await staking.totalStaked()).to.eq(totalStaked.add(amount))
})
function deposit(uint amount_) external {
  token.safeTransferFrom(msg.sender, address(this), amount_);
  balanceOf[msg.sender] += amount_;
  lastUpdated[msg.sender] = block.timestamp;
  totalStaked += amount_;
}
it("should revert if staking address not approved", async function () {
  await expect(staking.connect(account0).deposit(amount)).to.be.reverted
})
it("should revert if address has insufficient balance", async function () {
  const totalSupply = await token.totalSupply()
  await token.approve(staking.address, totalSupply)
  await expect(staking.deposit(totalSupply)).to.be.reverted
})

it("should emit Deposit event", async function () {
  await expect(staking.deposit(amount)).to.emit(staking, "Deposit").withArgs(
    signer.address, amount
  )
})
// ...
event Deposit(address address_, uint amount_);
// ...
function deposit(uint amount_) external {
  token.safeTransferFrom(msg.sender, address(this), amount_);
  balanceOf[msg.sender] += amount_;
  lastUpdated[msg.sender] = block.timestamp;
  totalStaked += amount_;
  emit Deposit(msg.sender, amount_);
}

it("should have 10 rewards after one hour", async function () {
  await time.increase(60*60)
  expect(await staking.rewards(signer.address)).to.eq(ethers.utils.parseEther("10"))
})

it("should have 1/36 rewards after one second", async function () {
  await time.increase(1)
  expect(await staking.rewards(signer.address)).to.eq(amount.div(1000).div(3600))
})

it("should have 0.1 reward after 36 seconds", async function () {
  await time.increase(36)
  expect(await staking.rewards(signer.address)).to.eq(ethers.utils.parseEther("0.1"))
})


function rewards(address address_) external view returns (uint) {
  return _rewards(address_);
}

function _rewards(address address_) internal view returns (uint) {
  return (block.timestamp - lastUpdated[address_]) * balanceOf[address_] / (rewardsPerHour * 1 hours);
}

it("should change token balances", async function () {
  await expect(staking.claim()).to.changeTokenBalances(token,
    [signer, staking],
    [reward, reward.mul(-1)]
  )
})

function claim() external {
  uint amount = _rewards(msg.sender);
  token.safeTransfer(msg.sender, amount);
}

it("should increment claimed", async function () {
  const claimed = await staking.claimed(signer.address)
  await staking.claim()
  expect(await staking.claimed(signer.address)).to.eq(claimed.add(reward))
})

// ...
mapping(address => uint) public claimed;
// ...
function claim() external {
  uint amount = _rewards(msg.sender);
  token.safeTransfer(msg.sender, amount);
  claimed[msg.sender] += amount;
}

it("should update lastUpdated claimed", async function () {
  await staking.claim()
  const timestamp = await time.latest()
  expect(await staking.lastUpdated(signer.address)).to.eq(timestamp)
})

function claim() external {
  uint amount = _rewards(msg.sender);
  token.safeTransfer(msg.sender, amount);
  claimed[msg.sender] += amount;
  lastUpdated[msg.sender] = block.timestamp;
}

it("should emit Claim event", async function () {
  await expect(staking.claim()).to.emit(staking, "Claim").withArgs(
    signer.address, reward
  )
})

// ...
event Claim(address address_, uint amount_);
// ...
function claim() external {
  uint amount = _rewards(msg.sender);
  token.safeTransfer(msg.sender, amount);
  claimed[msg.sender] += amount;
  lastUpdated[msg.sender] = block.timestamp;
  emit Claim(msg.sender, amount);
}
it("should not change token balances", async function () {
  await expect(staking.compound()).to.changeTokenBalances(token,
    [signer, staking],
    [0, 0]
  )
})

function compound() external {
  uint amount = _rewards(msg.sender);
  // No transfer function called
}

it("should increment claimed", async function () {
  const claimed = await staking.claimed(signer.address)
  await staking.compound()
  expect(await staking.claimed(signer.address)).to.eq(claimed.add(reward))
})

function compound() external {
  uint amount = _rewards(msg.sender);
  // No transfer function called
  claimed[msg.sender] += amount;
}

it("should increment account balance", async function () {
  const balanceOf = await staking.balanceOf(signer.address)
  await staking.compound()
  expect(await staking.balanceOf(signer.address)).to.eq(balanceOf.add(reward))
})

function compound() external {
  uint amount = _rewards(msg.sender);
  // No transfer function called
  claimed[msg.sender] += amount;
  balanceOf[msg.sender] += amount;
}

it("should increment total staked", async function () {
  const balance = await staking.totalStaked()
  await staking.compound()
  expect(await staking.totalStaked()).to.eq(balance.add(reward))
})

function compound() external {
  uint amount = _rewards(msg.sender);
  // No transfer function called
  claimed[msg.sender] += amount;
  balanceOf[msg.sender] += amount;
  totalStaked += amount;
}

it("should update lastUpdated", async function () {
  await staking.compound()
  const timestamp = await time.latest()
  expect(await staking.lastUpdated(signer.address)).to.eq(timestamp)
})

function compound() external {
  uint amount = _rewards(msg.sender);
  // No transfer function called
  claimed[msg.sender] += amount;
  balanceOf[msg.sender] += amount;
  totalStaked += amount;
  lastUpdated[msg.sender] = block.timestamp;
}

it("should emit Compound event", async function () {
  await expect(staking.compound()).to.emit(staking, "Compound").withArgs(
    signer.address, reward
  )
})

// ...
event Compound(address address_, uint amount_);
// ...
function compound() external {
  uint amount = _rewards(msg.sender);
  // No transfer function called
  claimed[msg.sender] += amount;
  balanceOf[msg.sender] += amount;
  totalStaked += amount;
  lastUpdated[msg.sender] = block.timestamp;
  emit Compound(msg.sender, amount);
}

it("should change token balances", async function () {
  amount = amount.div(2)
  await expect(staking.withdraw(amount)).to.changeTokenBalances(token,
    [signer, staking],
    [amount, amount.mul(-1)]
  )
})

function withdraw(uint amount_) external {
  token.safeTransfer(msg.sender, amount_);
}

it("should decrement account balance", async function () {
  const balanceOf = await staking.balanceOf(signer.address)
  await staking.withdraw(amount)
  expect(await staking.balanceOf(signer.address)).to.eq(balanceOf.sub(amount).add(reward))
})

function withdraw(uint amount_) external {
  token.safeTransfer(msg.sender, amount_);
  balanceOf[msg.sender] -= amount_;
}

it("should compound", async function () {
  await staking.withdraw(amount)
  const timestamp = await time.latest()
  expect(await staking.balanceOf(signer.address)).to.eq(reward)
  expect(await staking.claimed(signer.address)).to.eq(reward)
  expect(await staking.lastUpdated(signer.address)).to.eq(timestamp)
})

function compound() external {
  _compound();
}

function _compound() internal {
  uint amount = _rewards(msg.sender);
  // No transfer function called
  claimed[msg.sender] += amount;
  balanceOf[msg.sender] += amount;
  totalStaked += amount;
  lastUpdated[msg.sender] = block.timestamp;
  emit Compound(msg.sender, amount);
}

function withdraw(uint amount_) external {
  _compound();
  token.safeTransfer(msg.sender, amount_);
  balanceOf[msg.sender] -= amount_;
  totalStaked -= amount_;
}

it("should decrement token staked", async function () {
  const balance = await staking.totalStaked()
  await staking.withdraw(amount)
  expect(await staking.totalStaked()).to.eq(balance.sub(amount).add(reward))
})

it("should revert if amount greater than account balance", async function () {
  await expect(staking.withdraw(amount.add(1))).to.be.revertedWith("Insufficient funds")
})

function withdraw(uint amount_) external {
  require(balanceOf[msg.sender] >= amount_, "Insufficient funds");
  _compound();
  token.safeTransfer(msg.sender, amount_);
  balanceOf[msg.sender] -= amount_;
  totalStaked -= amount_;
}

it("should emit Withdraw event", async function () {
  await expect(staking.withdraw(amount)).to.emit(staking, "Withdraw").withArgs(
    signer.address, amount
  )
})

function withdraw(uint amount_) external {
  require(balanceOf[msg.sender] >= amount_, "Insufficient funds");
  _compound();
  token.safeTransfer(msg.sender, amount_);
  balanceOf[msg.sender] -= amount_;
  totalStaked -= amount_;
  emit Withdraw(msg.sender, amount_);
}

it("should compound before deposit", async function () {
  amount = amount.div(2)
  await staking.deposit(amount)
  await time.increase(60*60-1)
  const rewards = amount.div(1000)
  await staking.deposit(amount)
  expect(await staking.balanceOf(signer.address)).to.eq(amount.mul(2).add(rewards))
})

function deposit(uint amount_) external {
  _compound();
  token.safeTransferFrom(msg.sender, address(this), amount_);
  balanceOf[msg.sender] += amount_;
  lastUpdated[msg.sender] = block.timestamp;
  totalStaked += amount_;
  emit Deposit(msg.sender, amount_);
}
