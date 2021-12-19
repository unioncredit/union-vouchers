const { ethers } = require("ethers");
const { exec } = require("child_process");

const ABI = [
  {
    constant: false,
    inputs: [
      {
        internalType: "address",
        name: "borrower_",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "trustAmount",
        type: "uint256",
      },
    ],
    name: "updateTrust",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function",
  },
];

const MULTICALL_ABI = [
  {
    inputs: [
      {
        components: [
          {
            internalType: "address",
            name: "target",
            type: "address",
          },
          {
            internalType: "bytes",
            name: "callData",
            type: "bytes",
          },
        ],
        internalType: "struct Multicall.Call[]",
        name: "calls",
        type: "tuple[]",
      },
    ],
    name: "aggregate",
    outputs: [
      {
        internalType: "uint256",
        name: "blockNumber",
        type: "uint256",
      },
      {
        internalType: "bytes[]",
        name: "returnData",
        type: "bytes[]",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
];

async function main() {
  const vouchAmount = "1300000000000000000";
  const userManagerAddress = process.env.USER_MANAGER_ADDRESS;
  const addresses = process.argv.slice(2);

  const calls = addresses.map((address) => ({
    address: userManagerAddress,
    name: "updateTrust",
    params: [address, vouchAmount],
  }));

  const itf = new ethers.utils.Interface(ABI);

  const calldata = calls.map((call) => [
    call.address.toLowerCase(),
    itf.encodeFunctionData(call.name, call.params),
  ]);

  const mulitCallItf = new ethers.utils.Interface(MULTICALL_ABI);

  const mulitCallCalldata = mulitCallItf.encodeFunctionData("aggregate", [
    calldata,
  ]);

  const child = exec(`./bulkVouch.sh ${mulitCallCalldata}`);
  child.stdout.pipe(process.stdout);
  child.on("exit", function () {
    process.exit();
  });
}

main();
