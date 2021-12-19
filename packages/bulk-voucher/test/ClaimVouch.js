const { expect, use } = require("chai");
const chaiAsPromised = require("chai-as-promised");
use(chaiAsPromised);

describe("ClaimVouch", function () {
  let account, userManagerMock, claimVouch, erc20Mock;

  const vouchAmount = ethers.utils.parseEther("100");

  const maxClaimAmount = "10";

  beforeEach(async () => {
    const signers = await ethers.getSigners();
    account = signers[0];

    const UserManagerMock = await ethers.getContractFactory("UserManagerMock");
    userManagerMock = await UserManagerMock.deploy();

    const ClaimVouch = await ethers.getContractFactory("ClaimVouch");
    claimVouch = await ClaimVouch.deploy(
      vouchAmount,
      userManagerMock.address,
      maxClaimAmount
    );

    const ERC20Mock = await ethers.getContractFactory("MockToken");
    erc20Mock = await ERC20Mock.deploy();
  });

  async function expectTrustAmount(expected) {
    const value = await userManagerMock.trust(account.address);
    console.log(
      "[*] trust amount",
      ethers.utils.formatEther(value.toString()).toString()
    );
    expect(value.toString()).to.equal(expected);
  }

  async function expectBalanceOf(sender, amount) {
    const balance = await erc20Mock.balanceOf(sender);
    console.log("[*] balance of", sender, ethers.utils.formatEther(balance));
    expect(balance.toString()).to.equal(amount);
  }

  async function send(acc) {
    await (acc || account).sendTransaction({
      to: claimVouch.address,
      value: 0,
    });
  }

  it("rejected when not eligible", async () => {
    await expectTrustAmount("0");
    expect(send()).to.be.rejectedWith(Error);
  });

  it("address recieves vouch", async () => {
    await claimVouch.addEligible([account.address]);
    await send();
    await expectTrustAmount(vouchAmount.toString());
  });

  it("double vouch", async () => {
    await claimVouch.addEligible([account.address]);
    await send();
    expect(send()).to.be.rejectedWith(Error);
  });

  it("can withdraw erc20 token", async () => {
    const amount = ethers.utils.parseEther("100");
    await erc20Mock.mint(amount);
    await expectBalanceOf(claimVouch.address, "0");
    await erc20Mock.transfer(claimVouch.address, amount);
    await expectBalanceOf(claimVouch.address, amount.toString());
    const calldata = erc20Mock.interface.encodeFunctionData("transfer", [
      account.address,
      amount,
    ]);
    await claimVouch.call(erc20Mock.address, calldata);
    await expectBalanceOf(claimVouch.address, "0");
  });

  it("only 100 distinc address can claim", async () => {
    const accounts = await ethers.getSigners();
    console.log("[*] accounts: ", accounts.length);
    for (let i = 0; i < Number(maxClaimAmount); i++) {
      const acc = accounts[i];
      await claimVouch.addEligible([acc.address]);
      await send(acc);
    }

    expect(send(accounts[20])).to.be.rejectedWith(Error);
  });
});
