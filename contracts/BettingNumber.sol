// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract BettingNumber {
    
    uint256 private numberToGuess;
    uint256 pot;
    address private _owner;

    event NewBet(address indexed from, uint256 betAmount);

    struct Bet {
        address better;
        uint256 betAmount;
    }

    Bet[] bets;

    constructor() payable {
        console.log("Hello my name is Bryce and I'm betting :0");
        numberToGuess = 81;
        _owner = msg.sender;
    }

    function bet() external payable {
        //Create bet
        Bet memory betMade = Bet(msg.sender, msg.value);
        bets.push(betMade);
    }

    function getBets() public view returns (Bet[] memory) {
        console.log("Bets size: ", bets.length);
        return bets;
    }

    // function payOut() external onlyOwner {
    //     address payable _winner = ;
    //     _winner.transfer(_value);
    // }

    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }
}