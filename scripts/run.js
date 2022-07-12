const { hexStripZeros } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const BetContractFactory = await hre.ethers.getContractFactory("BettingNumber");
    const BetContract = await BetContractFactory.deploy();
    await BetContract.deployed();

    console.log("Contract deployed to:", BetContract.address);
    console.log("Contract deployed by:", owner.address);

    let betCount;
    betCount = await BetContract.getBets();

    let betTxn = await BetContract.bet({value: ethers.utils.parseEther("0.5")});
    await betTxn.wait();

    betCount = await BetContract.getBets();
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();