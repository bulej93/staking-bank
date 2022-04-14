// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.3;
import './Dai.sol';
import "hardhat/console.sol";

contract Bank {

    string public name;
    address admin;
    DaiToken public daiToken;
    uint deployTime;
    uint rewardTime;
    uint pool1;
    uint pool2;
    uint pool3;

    

    constructor(DaiToken _daiToken) {
        name = 'Bank';
        admin = msg.sender;
        daiToken = _daiToken;
        deployTime = block.timestamp;
        rewardTime = 3 days;
    }

    function depositRewards(uint _amount) public {
        require(msg.sender == admin);
        daiToken.transferFrom(admin, address(this), _amount);
    }

}