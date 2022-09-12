//SPDX-License-Identifier: MIT
pragma solidity >= 0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * Wallet.
 * 
 */
contract Wallet is Ownable { 

    struct Token {
        bytes32 ticker;
        address tokenAddress;
    }

    /* List of tickers */
    bytes32[] public tickerList;

    /* Mapping: ticker => token */
    mapping (bytes32 => Token) public tokens; 

    /* List of wallet owners */
    address[] public  ownerList;
    
    /* Double Mapping: balances[owner][ticker] => balance amount  */
    mapping (address =>  mapping (bytes32 => uint256 )) public balances;

    modifier tokenRegistered(bytes32 tokenTicker) {
       require( tokens[tokenTicker].tokenAddress != address(0), "Token not registered." );
        _;
    }

    function addToken(bytes32 ticker, address tokenAddress) onlyOwner external {
        tickerList.push(ticker);
        tokens[ticker] = Token (ticker, tokenAddress);
    }

    function withdraw (uint256 amount, bytes32 ticker) tokenRegistered(ticker) external {
        require( balances[msg.sender][ticker] >= amount, "Balance not sufficient.");

        balances[msg.sender][ticker] -= amount;
        IERC20( tokens[ticker].tokenAddress).transferFrom( address(this), msg.sender, amount);

    }


    function deposit (uint256 amount, bytes32 ticker) tokenRegistered(ticker) external {
        require( IERC20(tokens[ticker].tokenAddress).balanceOf(msg.sender) >= amount );

        // user shuld have given us an allowance in order to do the below transfer
        IERC20( tokens[ticker].tokenAddress).transferFrom( msg.sender, address(this) , amount);
        balances[msg.sender][ticker] += amount;

    }



}