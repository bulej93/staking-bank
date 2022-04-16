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
    uint pool3Stakers;

    mapping(address => uint) public balances;

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
        require(block.timestamp > rewardTime * 2 + deployTime);
        require(balances[msg.sender] > 0, 'balances need to be more than 0');
        //days pool 6
        if (block.timestamp > rewardTime * 2 + deployTime ) {
            uint _earnedReward = balances[msg.sender] * pool1 / totalStaked;
            daiToken.transfer(msg.sender, balances[msg.sender] + _earnedReward);
            console.log('reward at pool 1 %s', _earnedReward );
            if(block.timestamp < rewardTime * 3 + deployTime){
                stakers --; 
            } else {
                stakers = stakers;
            }
        } 
         console.log('stakers %s at end of pool 1', stakers);
        //9 days
        if(block.timestamp > rewardTime * 3 + deployTime ){
             console.log('stakers at of pool 2  %s', stakers);
            if(stakers > 1) {
                uint _earnedRewardP2 = balances[msg.sender] * pool2 / totalStaked;
                daiToken.transfer(msg.sender, _earnedRewardP2);
                console.log('reward at pool 2 not alone %s', _earnedRewardP2);
                
            } else {
                uint _earnedRewardP2 = pool2;
                daiToken.transfer(msg.sender, _earnedRewardP2);
                console.log('reward at pool 2 alone %s', _earnedRewardP2);
            }
        }
        
          console.log('pool3 stakers %s', stakers);

          //12 days

       
        if (block.timestamp > rewardTime * 4 + deployTime) {
            console.log('stakers %s at pool 3', stakers);
            if(stakers > 1){
                uint _earnedRewardP3 = balances[msg.sender] * pool3 / totalStaked;
                console.log('reward at pool 3 not alone %s', _earnedRewardP3);
                daiToken.transfer(msg.sender, _earnedRewardP3 );

             
            } else {
                uint _earnedRewardP3 = pool3;
                console.log('reward at pool 3 alone %s', _earnedRewardP3);
                daiToken.transfer(msg.sender, _earnedRewardP3);
            }
        }
         balances[msg.sender] =  balances[msg.sender] - balances[msg.sender];
         
         
    }

    function withdrawByBank() public {
        require(msg.sender == admin);
        require(daiToken.balanceOf(address(this)) != 0, 'sorry contract is empty');
        if(stakers == 0 && block.timestamp > rewardTime * 4 + deployTime){
            daiToken.transfer(admin, daiToken.balanceOf(address(this)));
        }
    }

}