const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");

describe("Bank contract", function () {

    let owner;
    let wallet1;
    let wallet2;
    let Bank;
    let bank;
    let DaiToken;
    let daitoken;
    let provider;

    beforeEach (async function() {
         [owner, wallet1, wallet2] = await ethers.getSigners();

         DaiToken = await ethers.getContractFactory('DaiToken');
         daitoken = await DaiToken.deploy()
         
         Bank = await ethers.getContractFactory("Bank");
         bank = await Bank.connect(owner).deploy(daitoken.address)
         
         
        //  bank = await Bank.deploy(daitoken.address, 100);
        //  await daitoken.approve(bank.address, 1000)
        //  await bank.connect(owner).depositRewards(1000)

         
         
        
    })

    it("It should deploy", async function () {
        
      expect(await bank.name()).to.equal('Bank')
      const ownerBalance = await daitoken.balanceOf(owner.address)
      //expect(await daitoken.totalSupply()).to.equal(ownerBalance)
      const bl = await daitoken.balanceOf(bank.address)

      // console.log(Bank)
    });

    it('deposit rewards', async function () {
      await daitoken.connect(owner).approve(bank.address, 1500)
      await bank.connect(owner).depositRewards(1500)
      expect(await daitoken.balanceOf(bank.address)).to.equal(1500)
    })

    it('should deposit staking tokens', async function () {
      await daitoken.connect(owner).approve(bank.address, 100)
      await bank.connect(owner).stakeTokens(100)
      await daitoken.connect(owner).transfer(wallet1.address, 1000)
      await daitoken.connect(wallet1).approve(bank.address, 1000)
      await bank.connect(wallet1).stakeTokens(500)
      expect(await daitoken.balanceOf(bank.address)).to.equal(600)
    })

    it('unstakes tokens', async function () {
      await daitoken.connect(owner).approve(bank.address, 150000)
      await bank.connect(owner).depositRewards(150000)
      await daitoken.connect(owner).approve(bank.address, 100)
      await bank.connect(owner).stakeTokens(100)
      await daitoken.connect(owner).transfer(wallet1.address, 1000)
      await daitoken.connect(wallet1).approve(bank.address, 1000)
      await bank.connect(wallet1).stakeTokens(500)
      await hre.ethers.provider.send('evm_increaseTime', [16 * 24 * 60 * 60]);
      await bank.connect(wallet1).unStakeTokens()
      await hre.ethers.provider.send('evm_increaseTime', [15 * 24 * 60 * 60]);
      await bank.connect(owner).unStakeTokens()
      expect(await daitoken.balanceOf(wallet1.address)).to.equal(500)
    })

    it('allow admin to withdraw', async function () {
      
    })

  });