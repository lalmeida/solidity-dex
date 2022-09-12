//SPDX-License-Identifier: MIT
pragma solidity >= 0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Link is ERC20 {
    
    constructor() ERC20("Chainlink mock", "LINK") {
        _mint(msg.sender, 1000);
    }
}