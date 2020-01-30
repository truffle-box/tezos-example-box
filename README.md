Tezos Example Box
=================

**Note: Experimental. Currently designed for demo purposes only.**

This box contains a `Counter` and simple `SimpleStorage` contract to display the basics of Tezos
integration with Truffle.


## Prerequisites

- [Docker](https://docs.docker.com/v17.12/install/)
  - Currently Docker must be running for LIGO compilations.
- [NodeJS](https://nodejs.org/en/)
  -  v8.9.4 to v12.2.0


## Installation

1. Install Truffle globally. Make sure you install `truffle@alphaTez`.
    ```
    npm install -g truffle@alphaTez
    ```

2. Download the box. This also takes care of installing the necessary dependencies.
    ```
    truffle unbox tezos-example
    ```


## Configuring Wallets

- A test faucet key can be obtained from https://faucet.tzalpha.net/. Once saved, it can be imported inside `truffle-config.js`:

  ```javascript

  const { mnemonic, secret, password: passphrase, email } = require("./faucet.json");

  module.exports = {
    networks: {
      development: {
        host: "https://babylonnet.smartpy.io",
        port: 443,
        network_id: "*",
        secret,
        mnemonic,
        passphrase,
        email,
        type: "tezos"
      }
    }
  };

  ```

- `truffle@alphaTez` also supports importing an activated account's secret key:

  ```javascript

  module.exports = {
    networks: {
      development: {
        host: "https://babylonnet.smartpy.io",
        port: 443,
        network_id: "*",
        secretKey: "edsk..." // private key
        type: "tezos"
      }
    }
  };
  ```


## Usage

- Compile, migrate, and test the smart contracts.

    ```
    truffle compile
    truffle migrate
    truffle test
    ```

