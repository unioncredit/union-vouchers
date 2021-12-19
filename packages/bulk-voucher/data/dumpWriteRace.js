const path = require("path");
const fs = require("fs");
const { request, gql } = require("graphql-request");
const unique = require("lodash/uniq");

const dumpPath = path.resolve("writeRaceAddressesDump.json");
const url = "https://race.mirror-api.com/graphql";

async function main() {
  const pageSize = 25;
  const maxRound = 31;

  const query = (roundNumber, page) => gql`
    {
      writeRaceRound(roundNumber: ${roundNumber}, limit: ${pageSize}, offset: ${
    page * pageSize
  }) {
        roundData {
          address
          votes
        }
      }
    }
  `;

  let page = 0;
  let round = 6;

  let results = [];

  while (true) {
    try {
      if (round > maxRound) {
        break;
      }

      const result = await request(url, query(round, page));
      const newResults = result.writeRaceRound.roundData;
      const length = newResults.length;

      if (length < pageSize) {
        round++;
        page = 0;
      }

      page++;
      results = unique([...results, ...newResults], "address");

      console.log(
        `[*] total: ${results.length}, page: ${page}, found: ${length}, round: ${round}`
      );
    } catch (error) {
      console.log(error);
      round++;
      page = 0;
    }
  }

  console.log("Results " + results.length);

  fs.writeFileSync(dumpPath, JSON.stringify(results));
}

if (require.main === module) {
  main();
}
