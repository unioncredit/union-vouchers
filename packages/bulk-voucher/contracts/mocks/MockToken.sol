pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20("mock", "mock") {
    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }
}
