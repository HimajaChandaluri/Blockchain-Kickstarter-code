const path = require("path");
const solc = require("solc");
const fs = require("fs-extra");

const projectPath = path.resolve(__dirname, "contracts", "Project.sol");
const source = fs.readFileSync(projectPath, "utf8");

const input = {
  language: "Solidity",
  sources: {
    "Project.sol": {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

module.exports = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
  "Project.sol"
].Project;
