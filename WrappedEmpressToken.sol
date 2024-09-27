// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "EmpressToken.sol";

contract WrappedEmpressToken is ERC20{
    EmpressToken public empressToken;

    constructor(address _empressToken) ERC20("Wrapped Empress Token", "WEMP") {
        empressToken = EmpressToken(_empressToken);
    }

    // Wrap EMP tokens - > WEMP tokens
    function wrap(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than zero");

        // Transfer EMP tokens from the user to this contract
        empressToken.transferToken(msg.sender, address(this), _amount);

        // Mint WEMP tokens to the user
        _mint(msg.sender, _amount*(10 ** uint256(decimals())));
    }

    // Unwrap EMP tokens - > WEMP tokens
    function unwrap(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than zero");

        // Burn WEMP tokens from the user
        _burn(msg.sender, _amount*(10 ** uint256(decimals())));

        // Transfer the corresponding amount of EMP tokens back to the user
        empressToken.transferToken(address(this),msg.sender, _amount);
    }
}
