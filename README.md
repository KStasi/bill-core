# Bill-Core

## Overview

Bill-Core is a blockchain-based billing system designed for invoice issuance and management on Ripple's EVM Sidechain. The smart contracts in this repository are designed to facilitate cross-chain interactions, supporting various assets on different chains while centralizing the main storage and flow on the XRPL EVM Sidechain.

## Smart Contracts

**Cross-Chain Payment Proxies**:

- **ERC20PaymentProxy**: Facilitates ERC20 token payments across multiple chains.
- **NativePaymentProxy**: Handles native cryptocurrency transactions (like ETH) on various blockchain networks.
  **Request**: Represents specific payment request on Ripple's EVM Sidechain.
  **RequestFactory**: Automates the deployment and simplifies tracking of new request contracts.

## Quick Start

Try running the following command:

```shell
npm install
npm compile
npm deploy
```

Make sure to provide env variables or create .env file with the `INFURA_KEY` and `PRIVATE_KEY` for the deployment.

## Deployed contracts

**XRPL EVM Sidechain:**

==RequestFactory addr= 0xCc6a1C5CecEFC85Ee80350D6820152D1081fE48a

==ERC20PaymentProxy addr= 0x6FbEf10f8e1Ae82A66ee6AEec394A9f0c6a64263

==NativePaymentProxy addr= 0xe198285bD9EA7A3Bf10065DA711F45B6D4A3761F

## License

This project is licensed under the MIT License. See the `LICENSE` file in the repository for more information.
