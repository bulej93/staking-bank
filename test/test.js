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
         
         Bank = await ethers.getContractFactory("Bank", await daitoken.approve(Bank.address, 100));
         bank = await Bank.connect(owner).deploy(daitoken.address, 100)
         
         
        //  bank = await Bank.deploy(daitoken.address, 100);
        //  await daitoken.approve(bank.address, 1000)
        //  await bank.connect(owner).depositRewards(1000)

         
         
        
    })

    it("It should deploy", async function () {
        
      expect(await bank.name()).to.equal('Bank')
      const ownerBalance = await daitoken.balanceOf(owner.address)
      //expect(await daitoken.totalSupply()).to.equal(ownerBalance)


      const bl = await daitoken.balanceOf(bank.address)

      console.log(Bank)
    });

  });