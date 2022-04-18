
const hre = require("hardhat");

async function main() {
 
  const DaiToken = await hre.ethers.getContractFactory("DaiToken");
  const dai = await DaiToken.deploy();
  await dai.deployed()
  console.log("dai token deployed to:", dai.address);


  const Bank = await hre.ethers.getContractFactory("Bank");
  const bank = await Bank.deploy(dai.address);
  await bank.deployed()
  console.log("bank deployed to:", bank.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
