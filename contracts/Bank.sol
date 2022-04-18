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
    uint totalRewards;
    uint pool1;
    uint pool2;
    uint pool3;
    uint totalStaked;
    uint stakers;
    uint pool1Stakers;
    uint pool2Stakers;
    uint pool3Stakers;

    mapping(address => uint) public balances;

    constructor(DaiToken _daiToken) {
        name = 'Bank';
        admin = msg.sender;
        daiToken = _daiToken;
        deployTime = block.timestamp;
        rewardTime = 3 days;
        stakers = 0;
        pool1Stakers = 0;
        pool2Stakers = 0;
        pool3Stakers = 0;
        
    }

    function depositRewards(uint _amount) public {
        require(msg.sender == admin);
        daiToken.transferFrom(admin, address(this), _amount);
        totalRewards = daiToken.balanceOf(address(this));
        pool1 = daiToken.balanceOf(address(this)) / 100 * 20;
        pool2 = daiToken.balanceOf(address(this)) / 100 * 30;
        pool3 = daiToken.balanceOf(address(this)) / 100 * 50;
    }

    function stakeTokens(uint _amount) public {
        require(block.timestamp < deployTime + rewardTime, 'sorry time has passed for deposits');
        daiToken.transferFrom(msg.sender, address(this), _amount);
        balances[msg.sender] = balances[msg.sender] +  _amount;
        totalStaked = totalStaked + _amount;
        stakers ++;
    }
    
    function unStakeTokens() public {
        require(block.timestamp >= rewardTime * 2 + deployTime, 'not yet time to unstake');
        require(balances[msg.sender] > 0, 'balances need to be more than 0');
        
        if (block.timestamp > rewardTime * 2 + deployTime ) {
            uint _earnedReward = balances[msg.sender] * pool1 / totalStaked;
            daiToken.transfer(msg.sender, balances[msg.sender] + _earnedReward);
            if(block.timestamp < rewardTime * 3 + deployTime){
                pool1Stakers ++; 
                pool2Stakers ++;
            }
        } 
        
        if(block.timestamp > rewardTime * 3 + deployTime ){
            uint _alonePool2 = stakers - pool1Stakers;
            if(pool1Stakers == 0 || _alonePool2 > 1) {
                uint _earnedRewardP2 = balances[msg.sender] * pool2 / totalStaked;
                daiToken.transfer(msg.sender, _earnedRewardP2);
            } 
            if (_alonePool2 == 1){
                uint _earnedRewardP2 = pool2;
                daiToken.transfer(msg.sender, _earnedRewardP2);
            }

            if(block.timestamp < rewardTime * 4 + deployTime){
                pool2Stakers ++; 
            }
        }

       
        if (block.timestamp > rewardTime * 4 + deployTime) {
            uint _alonePool3 = stakers - pool2Stakers;
            if(pool2Stakers == 0 || _alonePool3 > 1){
                uint _earnedRewardP3 = balances[msg.sender] * pool3 / totalStaked;
                daiToken.transfer(msg.sender, _earnedRewardP3 );
            } 
            
            if(_alonePool3 == 1) {
                uint _earnedRewardP3 = pool3;
                daiToken.transfer(msg.sender, _earnedRewardP3);
            } 

            if(block.timestamp > rewardTime * 4 + deployTime){
                pool3Stakers++;
            }

        }
         balances[msg.sender] =  balances[msg.sender] - balances[msg.sender];
         
         
    }

    function withdrawByBank() public {
        uint _amount = daiToken.balanceOf(address(this));
        require(block.timestamp > rewardTime * 4 + deployTime, 'not yet time to withdraw');
        require(msg.sender == admin, 'you are not admin');
        require(daiToken.balanceOf(address(this)) != 0, 'sorry contract is empty');
        if( pool3Stakers == 0){
            daiToken.transfer(admin, _amount);
        }
    }

}