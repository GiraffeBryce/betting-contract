const { hexStripZeros } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

const main = async () => {
    const [owner, better1, better2] = await hre.ethers.getSigners();
    const BetContractFactory = await hre.ethers.getContractFactory("BettingNumber");
    const BetContract = await BetContractFactory.deploy();
    await BetContract.deployed();

    console.log("Contract deployed to:", BetContract.address);
    console.log("Contract deployed by:", owner.address);
    console.log("Soon to be betters:", better1.address, better2.address);

    // Initial betCount should be 0, pot size 0
    let betCount;
    betCount = await BetContract.getBets();
    let potSize;
    potSize = await BetContract.getPot();

    // Make bets of 0.5 by Ox70 on number 79, 1.2 by 0x3C on number 94
    let betTxn = await BetContract.connect(better1).bet(79, {value: ethers.utils.parseEther("0.5")});
    await betTxn.wait();

    let betTxn2 = await BetContract.connect(better2).bet(94, {value: ethers.utils.parseEther("1.2")});
    await betTxn2.wait();
    // Note: 0x70 should be winner

    // Check if betCount and potSize have right amounts
    betCount = await BetContract.getBets();
    potSize = await BetContract.getPot();

    // Check if potSize matches contract balance
    contractBalance = await hre.ethers.provider.getBalance(BetContract.address);
    console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
    );

    // Pay out the potSize to the closest winner
    let payOutTxn = await BetContract.connect(owner).payOut();
    await payOutTxn.wait();

    // Check if betCount and potSize have reset to 0
    betCount = await BetContract.getBets();
    potSize = await BetContract.getPot();

    // Check if potSize matches contract balance
    contractBalance = await hre.ethers.provider.getBalance(BetContract.address);
    console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
    );
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