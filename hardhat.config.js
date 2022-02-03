// require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const projectId = process.env.ALCHEMY_PROJECT_ID_RINKEBY;
const privateKey = process.env.DEPLOYER_SIGNER_PRIVATE_KEY;
// const etherscanApiKey = process.env.ETHERSCAN_API_KEY_TOKEN

module.exports = {
  solidity: "0.8.4",
  // etherscan: {
  //   apiKey: etherscanApiKey,
  // },
  networks: {
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${projectId}`,
      accounts: [privateKey],
    },
  },
};

// Verify contract: npx hardhat verify YOUR_CONTRACT_ADDRESS --network rinkeby
// Verify contract: npx hardhat verify 0x9a59CFc34ABED8FDE5989892A1D2B75235d14b14 --network rinkeby
