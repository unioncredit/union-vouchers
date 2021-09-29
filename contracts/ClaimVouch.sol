pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IUserManager {
    function updateTrust(address borrower, uint256 trustAmount) external;
}

contract ClaimVouch is Ownable {
    mapping(address => bool) public addresses;

    mapping(address => bool) public claims;

    uint256 public vouchAmount;

    IUserManager public userManager;

    constructor(uint256 _vouchAmount, IUserManager _userManager) {
        vouchAmount = _vouchAmount;
        userManager = _userManager;
    }

    function setVouchAmount(uint256 _vouchAmount) public onlyOwner {
        vouchAmount = _vouchAmount;
    }

    receive() external payable {
        require(claims[msg.sender] == false, "already claimed");
        require(addresses[msg.sender] == true, "not eligible");
        claims[msg.sender] = true;
        userManager.updateTrust(msg.sender, vouchAmount);
    }

    function addEligible(address[] memory addr) external onlyOwner {
        for (uint256 i = 0; i < addr.length; i++) {
            addresses[addr[i]] = true;
        }
    }

    function call(address target, bytes memory callData)
        public
        onlyOwner
        returns (bytes memory)
    {
        (bool success, bytes memory ret) = target.call(callData);
        require(success);
        return ret;
    }
}
