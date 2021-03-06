const path = require("path");
const fs = require("fs");
const { request, gql } = require("graphql-request");

const pageSize = 1000;
const dumpPath = path.resolve("poapAddressesDump-xdai.txt");
const dumpDataPath = path.resolve("poapAddressesDump-xdai-unfiltered.json");
// const url = "https://api.thegraph.com/subgraphs/name/amxx/poap";
// xdai
const url = "https://api.thegraph.com/subgraphs/name/poap-xyz/poap-xdai";

async function main() {
  const query = (timestamp) => gql`
    {
      transfers(first: ${pageSize}, where: {timestamp_gt:${timestamp}}) {
        timestamp
        token {
          id
        }
        to {
          id
        }
      }
    }
  `;

  let timestamp = 1588623021;

  let results = {};

  while (true) {
    const result = await request(url, query(timestamp));
    const transfers = result.transfers;

    console.log(`[*] results: ${Object.keys(results).length}`);

    if (transfers.length < pageSize) {
      break;
    }

    for (let i = 0; i < transfers.length; i++) {
      const row = transfers[i];
      const data = results[row.to.id] || [];
      results[row.to.id] = [
        ...data,
        { timestamp: row.timestamp, to: row.to.id },
      ];
      timestamp = row.timestamp;
    }
  }

  const filtered = Object.values(results).filter((arr) => arr.length >= 3);
  const addresses = filtered.map((item) => item[0].to);

  console.log(`Found ${addresses.length} addresses`);
  fs.writeFileSync(dumpPath, addresses.join("\n"));
  fs.writeFileSync(dumpDataPath, JSON.stringify(results));
}

if (require.main === module) {
  main();
}
