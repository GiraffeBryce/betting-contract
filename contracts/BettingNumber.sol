// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract BettingNumber {
    
    int256 private numberToGuess;
    uint256 pot;
    address private _owner;
    uint256 MAX_INT;
    AggregatorV3Interface public priceFeed;

    event NewBet(address indexed from, uint256 betAmount);

    struct Bet {
        address payable better;
        uint256 betAmount;
        int256 guess;
    }

    Bet[] bets;
    Bet[] closestBet;

    constructor() payable {
        console.log("Hello my name is Bryce and I'm the casino owner :0");
        console.log("Must guess a positive integer.");
        numberToGuess = 81;
        _owner = msg.sender;
        MAX_INT = 2**256 - 1;
        pot = 0 ether;
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    }

    function bet(int256 guess) external payable {
        //Create bet
        Bet memory betMade = Bet(payable(msg.sender), msg.value, guess);
        bets.push(betMade);
        console.log("Adding to pot: ", msg.value);
        pot += msg.value;
    }

    function getLatestPrice() public view returns (int) {
        (, int price,,,) = priceFeed.latestRoundData();
        return price;
    }

    function getDecimals() public view returns (uint8) {
        uint8 decimals = priceFeed.decimals();
        return decimals;
    }

    function getBets() public view returns (Bet[] memory) {
        console.log("Bets size: ", bets.length);
        return bets;
    }

    function getPot() public view returns (uint256) {
        console.log("Pot size: ", pot);
        return pot;
    }

    function abs(int x) private pure returns (int) {
        return x>=0 ? x : -x;
    }

    function payOut() external payable {
        require(msg.sender == _owner);
        
        // iterate through bets to find closest bet
        for(uint i=0; i<bets.length; i++){
            if(closestBet.length>0) {
                // console.log("Closest better for now:", closestBet[0].better, "Guess: ", uint256(closestBet[0].guess));
                // int error = abs(bets[i].guess - numberToGuess);
                // int topGuessError = abs(closestBet[0].guess - numberToGuess);
                // console.log("Error of guess:", uint256(error));
                // console.log("Top guess right now:", uint256(topGuessError));
                if(abs(bets[i].guess - numberToGuess) == abs(closestBet[0].guess - numberToGuess)) {
                    closestBet.push(bets[i]);
                    console.log("Another winner: ", bets[i].better);
                }
                if(abs(bets[i].guess - numberToGuess) < abs(closestBet[0].guess - numberToGuess)) {
                    delete closestBet;
                    closestBet.push(bets[i]);
                    console.log("New winner: ", bets[i].better);
                }
                else {
                    console.log("This person didn't win:", bets[i].better);
                }
            }
            else {
                closestBet.push(bets[i]);
                console.log("New winner for now...: ", bets[i].better);
            }
            
        }
        console.log("Current closestBet size:", closestBet.length);
        // if there's only 1 winner, payout to winner
        if(closestBet.length == 1){
            console.log("Only one winner!");
            closestBet[0].better.transfer(pot);
            console.log(closestBet[0].better, "is the winner!");
            console.log("Pay out done.");
        }
        
        // if there's no winner, payout to no one
        if(closestBet.length == 0){
            console.log("No winner, no payout!");
        }

        // if there's multiple winners, split up the pot

        if(closestBet.length > 1){
            console.log("Multiple winners, split the pot!");
            uint256 splitPot = pot/closestBet.length;
            console.log("Pay out to winners:", splitPot);
            for(uint i=0; i<closestBet.length; i++){
                closestBet[i].better.transfer(splitPot);
                console.log(closestBet[i].better, "is a winner!");
            }
            console.log("Pay out done.");
        }
        pot = 0;
        // console.log("Pot size now:", pot);
        delete bets;
        // console.log("Bets reset. Size: ", bets.length);
        delete closestBet;
        // console.log("Closest bets reset. Size: ", closestBet.length);
    }

}