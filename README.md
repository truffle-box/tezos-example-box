Tezos Example Box
=================

**Note: Experimental. Currently designed for demo purposes only.**

This box contains a simple `SimpleStorage` contract to display the basics of Tezos
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

3. Compile and migrate the smart contract.
    ```
    truffle compile
    truffle migrate
    truffle test
    ```

