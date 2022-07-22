const { hexStripZeros } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

const main = async () => {
    const [deployer] = await hre.ethers.getSigners();
    const BetContractFactory = await hre.ethers.getContractFactory("BettingNumber");
    const BetContract = await BetContractFactory.deploy();
    await BetContract.deployed();

    console.log("Contract deployed to:", BetContract.address);
    console.log("Contract deployed by:", deployer.address);

    // Get ETH/USD price and decimals
    let price;
    console.log("Getting price: ");
    price = await BetContract.getLatestPrice();
    console.log((price.toString()));

    let decimals;
    console.log("Getting decimals: ");
    decimals = await BetContract.getDecimals();
    console.log(decimals.toString());

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