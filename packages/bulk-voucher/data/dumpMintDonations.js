const path = require("path");
const fs = require("fs");
const { EtherscanProvider } = require("@ethersproject/providers");

const dumpPath = path.resolve("mintDonationAddressesDump.txt");
const mintDonationAddress = "0xC1987f61BDCB5459Afc2C835A66D16c844fd7a54";
const etherscanApiKey = process.env.ETHERSCAN_API_KEY;

const provider = new EtherscanProvider("mainnet", etherscanApiKey);

async function main() {
  const history = await provider.getHistory(mintDonationAddress);
  const filtered = history.filter((item) => item.value.gt(0));
  const addresses = filtered.map((item) => item.from);
  console.log(`Found ${addresses.length} addresses`);
  fs.writeFileSync(dumpPath, addresses.join("\n"));
}

if (require.main === module) {
  main();
}
