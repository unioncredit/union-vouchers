pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IUserManager {
  function updateTrust(address borrower, uint256 trustAmount) external;
}

contract ClaimVouch is Ownable {
  mapping(address => bool) public addresses;

  mapping(address => bool) public claims;

  uint256 public vouchAmount;

  uint256 public claimCount;

  uint256 public maxClaimCount;

  IUserManager public userManager;

  constructor(
    uint256 _vouchAmount,
    IUserManager _userManager,
    uint256 _maxClaimCount
  ) {
    vouchAmount = _vouchAmount;
    userManager = _userManager;
    maxClaimCount = _maxClaimCount;
  }

  function setVouchAmount(uint256 _vouchAmount) public onlyOwner {
    vouchAmount = _vouchAmount;
  }

  function setMaxClaimAmount(uint256 _maxClaimCount) public onlyOwner {
    maxClaimCount = _maxClaimCount;
  }

  receive() external payable {
    require(claimCount < maxClaimCount, "no claims left");
    require(claims[msg.sender] == false, "already claimed");
    require(addresses[msg.sender] == true, "not eligible");
    claims[msg.sender] = true;
    userManager.updateTrust(msg.sender, vouchAmount);
    claimCount++;
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
