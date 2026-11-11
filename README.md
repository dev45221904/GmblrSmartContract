# Gmblr — Chainlink VRF Lottery

Gmblr is a minimal, fixed-ticket lottery smart contract built with Solidity and Foundry. Five numbered tickets are available for **0.001 ETH** each. Once every ticket is sold, the contract owner requests a verifiably random winner from Chainlink VRF. The owner cannot select the winner; the ticket owner chosen by VRF claims the complete prize pool.

> This repository is an educational prototype. It has not been audited. Do not use it for production or real-money gambling without a professional security review and confirming the laws that apply to you and your users.

## Features

- Five predefined ticket numbers: `11293`, `11246`, `11563`, `11111`, and `11456`
- Fixed price of `0.001 ETH` per ticket
- One ticket per wallet
- Ticket ownership recorded on-chain
- Chainlink VRF v2.5 for verifiable randomness
- Owner-only draw request after all tickets sell
- Winner-only, one-time prize claim
- Foundry deployment script and a basic test

## Contract lifecycle

```text
Buy an available ticket (0.001 ETH)
             |
             v
All five tickets are sold
             |
             v
Owner calls drawWinner()
             |
             v
Chainlink VRF fulfills the random-word request
             |
             v
Winning ticket is stored and emitted
             |
             v
Its owner calls claimPrize()
```

## Contract

| Item | Value |
| --- | --- |
| Source | `src/gmblr.sol` |
| Contract | `Gmblr` |
| Ticket price | `0.001 ETH` (`1e15` wei) |
| Randomness | Chainlink VRF v2.5, subscription billing |
| VRF network configuration | Ethereum Sepolia |

### Public functions

| Function | Who can call it | Purpose |
| --- | --- | --- |
| `purchase(uint256 index)` | Any wallet | Buys an available ticket at the specified array index, supplying exactly `price`. |
| `drawWinner()` | Owner | Requests randomness once every ticket is sold. |
| `claimPrize()` | Winning-ticket owner | Withdraws the entire contract balance once. |
| `isWinner(address user)` | Anyone | Checks whether an address owns the winning ticket. |

The key emitted events are `TicketPurchased`, `DrawRequested`, `WinnerPicked`, and `PrizeClaimed`.

## Sepolia deployment record

A successful deployment is recorded in `broadcast/gmblr.s.sol/11155111/run-latest.json`.

| Network | Chain ID | Contract |
| --- | ---: | --- |
| Ethereum Sepolia | `11155111` | [`0x5eF7a6c490B61CD9522b055c601b277b1e42Ea69`](https://sepolia.etherscan.io/address/0x5eF7a6c490B61CD9522b055c601b277b1e42Ea69) |

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) (`forge`, `cast`, and `anvil`)
- A funded Sepolia account for deployment gas
- A Chainlink VRF v2.5 subscription that has LINK funded and this contract added as a consumer after deployment
- A Sepolia RPC endpoint

## Installation

Clone the repository including its submodules:

```powershell
git clone --recurse-submodules <repository-url>
Set-Location NewOne
```

If the repository was cloned already, initialize its dependencies with:

```powershell
git submodule update --init --recursive
```

## Environment configuration

Create a local `.env` file. It is ignored by Git and must never be committed.

```dotenv
RPC_URL=https://sepolia.infura.io/v3/<your-api-key>
PRIVATE_KEY=<your-private-key-without-0x>
SUB_ID=<your-chainlink-vrf-v2-5-subscription-id>
```

In PowerShell, load the values into the current session before running deployment commands:

```powershell
Get-Content .env | ForEach-Object {
  if ($_ -match '^(?<name>[^#][^=]*)=(?<value>.*)$') {
    Set-Item -Path "Env:$($matches.name)" -Value $matches.value
  }
}
```

## Build and test

```powershell
forge build
forge test -vvv
```

The existing test verifies the ticket price. Before treating this as production-ready, add tests for every purchase, draw, fulfillment, claim, and failure path.

## Deploy to Sepolia

After loading your environment variables:

```powershell
forge script script/gmblr.s.sol:Deploy --rpc-url $env:RPC_URL --broadcast
```

After deployment, add the deployed contract address as a consumer to the VRF subscription identified by `SUB_ID`. Without that step, the coordinator cannot fulfill `drawWinner()` requests.

## Project structure

```text
src/gmblr.sol             Lottery contract
script/gmblr.s.sol        Foundry deployment script
test/test.t.sol           Foundry tests
broadcast/                Deployment transaction records
lib/forge-std/            Foundry standard library (submodule)
lib/chainlink-brownie-contracts/  Chainlink contracts (submodule)
```

## Known limitations

- The ticket list and ticket price are fixed at deployment.
- Each wallet can buy only one ticket for the lifetime of the contract.
- The contract supports one draw only; it does not create recurring rounds.
- There is no cancellation, refund, fee, timeout, or emergency recovery flow.
- This contract is unaudited and should be treated as a learning project.

## Suggested next improvements

- Create independent raffle rounds with configurable tickets, price, and deadlines.
- Add clear round states: `Open`, `RandomnessRequested`, `Completed`, and `Cancelled`.
- Support refunds when a round expires without enough ticket sales.
- Add comprehensive Foundry unit, fuzz, and invariant tests.
- Build a frontend using viem/wagmi or Scaffold-ETH for ticket selection and event-driven status updates.
- Obtain an independent security review before any production use.
