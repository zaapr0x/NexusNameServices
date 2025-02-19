require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    nexus: {
      url: process.env.RPC_URL,
      chainId: 392,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
