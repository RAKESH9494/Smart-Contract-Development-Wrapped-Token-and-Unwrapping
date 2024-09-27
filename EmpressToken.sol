// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EmpressToken is ERC20{
    constructor() ERC20("Empress Token", "EMP") {
        _mint(address(this), 1000*(10 ** uint256(decimals())));
    }
    function BuyToken(uint _amount) public {
        require(balanceOf(address(this)) >= _amount, "Not enough tokens in contract");
        transferToken(address(this), msg.sender, _amount);
    }
    
    function transferToken(address from, address to, uint amount) public  {
        _transfer(from, to, amount*(10 ** uint256(decimals())));
    }
}
