pragma solidity ^0.8.0;

contract UserManagerMock {
    mapping(address => uint256) public trust;

    function updateTrust(address borrower, uint256 trustAmount) external {
        trust[borrower] = trustAmount;
    }
}
