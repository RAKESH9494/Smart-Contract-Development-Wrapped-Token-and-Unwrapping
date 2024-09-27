## Overview
The contracts, `EmpressToken` and `WrappedEmpressToken`, work together to create a system where a native token (`EmpressToken`) can be "wrapped" into a different token (`WrappedEmpressToken` or `WEMP`).

### `EmpressToken`
`EmpressToken` is a basic ERC-20 token contract representing a token named "Empress Token" with the symbol "EMP". It allows users to buy the tokens and transfer them.

#### Components:

##### Constructor:
```solidity
constructor() ERC20("Empress Token", "EMP") {
    _mint(address(this), 1000*(10 ** uint256(decimals())));
}
```
  The constructor initializes the contract by minting 1,000 `EMP` tokens to the contract itself. The tokens are assigned to the contract’s address (`address(this)`).
  
##### Functions:

1. **BuyToken**:
  Allows users to buy `EMP` tokens by transferring tokens from the contract’s balance to the user’s address.

```solidity
function BuyToken(uint _amount) public {
    require(balanceOf(address(this)) >= _amount, "Not enough tokens in contract");
    transferToken(address(this), msg.sender, _amount);
}
```  
- **Logic**: 
  - The function checks if the contract has enough tokens to fulfill the purchase.
  - If enough tokens are available, it transfers the specified amount of `EMP` tokens from the contract to the caller (buyer).

2. **transferToken**:
  Transfers `EMP` tokens between two addresses.

```solidity
function transferToken(address from, address to, uint amount) public {
    _transfer(from, to, amount*(10 ** uint256(decimals())));
}
```
- **Logic**:
  - The function multiplies the token amount by the token's decimal factor and then calls the internal `_transfer` function of the ERC-20 contract to move the tokens from one address to another.


### `WrappedEmpressToken`
`WrappedEmpressToken` (symbol "WEMP") allows users to wrap and unwrap `EmpressToken` (EMP) into `WEMP` tokens. This is a common practice in decentralized finance (DeFi) to wrap tokens into a new token format, which might have different uses or functionality.

#### Key Components:

##### Constructor:
```solidity
constructor(address _empressToken) ERC20("Wrapped Empress Token", "WEMP") {
    empressToken = EmpressToken(_empressToken);
}
```
- **Purpose**: 
  The constructor initializes the `WrappedEmpressToken` contract and links it to the `EmpressToken` contract by passing its address as `_empressToken`.

##### Functions:

1. **wrap**:
  Allows users to wrap their `EMP` tokens into `WEMP` tokens.

```solidity
function wrap(uint256 _amount) external {
    require(_amount > 0, "Amount must be greater than zero");
    
    // Transfer EMP tokens from the user to this contract
    empressToken.transferToken(msg.sender, address(this), _amount);

    // Mint WEMP tokens to the user
    _mint(msg.sender, _amount*(10 ** uint256(decimals())));
}
```  
- **Logic**:
  - First, it checks that the amount of tokens being wrapped is greater than zero.
  - The function transfers `EMP` tokens from the user’s address to the contract’s address (`address(this)`).
  - After receiving the `EMP` tokens, the contract mints the same amount of `WEMP` tokens for the user, scaled by the token’s decimal factor.

2. **unwrap**:
  Allows users to unwrap their `WEMP` tokens back into `EMP` tokens.

```solidity
function unwrap(uint256 _amount) external {
    require(_amount > 0, "Amount must be greater than zero");

    // Burn WEMP tokens from the user
    _burn(msg.sender, _amount*(10 ** uint256(decimals())));

    // Transfer the corresponding amount of EMP tokens back to the user
    empressToken.transferToken(address(this),msg.sender, _amount);
}
```
- **Logic**:
  - First, it checks that the amount of tokens to be unwrapped is greater than zero.
  - The contract burns the specified amount of `WEMP` tokens from the user.
  - Then, the contract transfers the same amount of `EMP` tokens back to the user from the contract’s balance.

### How the Wrapping/Unwrapping Process Works:
1. **Wrapping (EMP to WEMP)**:
   - The user sends `EMP` tokens to the `WrappedEmpressToken` contract.
   - For every 1 `EMP` sent, the contract mints 1 `WEMP` token to the user, thus "wrapping" the tokens.

2. **Unwrapping (WEMP to EMP)**:
   - The user sends `WEMP` tokens back to the contract.
   - The contract burns these `WEMP` tokens and returns the corresponding amount of `EMP` tokens to the user, effectively "unwrapping" the tokens.
