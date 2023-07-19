# EVM Placeholder Proof System Verifier 

[![Discord](https://img.shields.io/discord/969303013749579846.svg?logo=discord&style=flat-square)](https://discord.gg/KmTAEjbmM3)
[![Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=flat-square&logo=telegram&logoColor=dark)](https://t.me/nilfoundation)
[![Twitter](https://img.shields.io/twitter/follow/nil_foundation)](https://twitter.com/nil_foundation)

Smart contracts for in-EVM validation of zero-knowledge proofs 
generated with the Placeholder proof system. 

## Dependencies

- [Hardhat](https://hardhat.org/)
- [Node.js](https://nodejs.org/en/) LTS version (>= 16.0, <= 18.x)

# Getting started

## Clone
```
git clone git@github.com:NilFoundation/evm-placeholder-verification.git
cd evm-placeholder-verification
```

## Install dependency packages

Start by installing npm packages:

```
npm install
```

## Compile contracts

```
npx hardhat compile
```

## Test

``` bash
#Execute tests
npx hardhat test 
# Test with gas reporting
REPORT_GAS=true npx hardhat test
```

## Deploy

Launch a local network:
```bash
npx hardhat node
```

Deploy to a test environment, such as Ganache:

```bash
npx hardhat deploy --network localhost 
```

Hardhat re-uses old deployments, to force re-deploy add the `--reset` flag above

# Verifying zkLLVM outputs


To verify a proof, produced with a zkLLVM circuit, 
Place a directory with ZKLLVM circuit transpilation outputs under the `contracts/zkllvm/` directory.



ZKLLVM circuit transpilation output folder format

* `proof.bin` -- placeholder proof file
* `circuit_params.json` -- parameters JSON file
* `public_input.json` -- public input JSON file
* `linked_libs_list.json` -- list of external libraries, have to be deployed for gate argument computation.
* `gate_argument.sol`, `gate0.sol`, ... `gateN.sol` -- solidity files with gate argument computation

Deploy contracts
```bash
npx hardhat deploy
```

Verify one folder from `contracts/zkllvm` directory
```bash
npx hardhat verify-circuit-proof --test folder-name
```

Verify all folders from `contracts/zkllvm` director
```
npx hardhat verify-circuit-proof-all
```

## Community

Issue reports are preferred to be done with Github Issues in here: https://github.com/NilFoundation/evm-placeholder-verification/issues.

Usage and development questions are preferred to be asked in a Telegram chat: https://t.me/nilfoundation or in Discord (https://discord.gg/KmTAEjbmM3)
