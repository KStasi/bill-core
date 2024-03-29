import { HardhatUserConfig } from "hardhat/config";
// import "@nomicfoundation/hardhat-toolbox";
import "hardhat-deploy";
import "@nomiclabs/hardhat-ethers";

const dotenv = require("dotenv");
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    goerli: {
      url: "https://goerli.infura.io/v3/" + process.env.INFURA_KEY,
      accounts: [process.env.PRIVATE_KEY || ""],
      chainId: 5,
    },
    xrplEVM: {
      url: "https://rpc-evm-sidechain.xrpl.org",
      accounts: [process.env.PRIVATE_KEY || ""],
      chainId: 1440002,
    },
  },
};

export default config;
