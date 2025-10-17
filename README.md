# 🔐 PasswordTrap — A Drosera-Compatible Monitoring Trap

## Overview

**PasswordTrap** is a lightweight [Drosera](https://dev.drosera.io) trap that continuously monitors an on-chain contract (`KeyContract`) for a specific password match (e.g. `"open-sesame"`).  
When the stored string in `KeyContract` matches the configured target password hash, the trap triggers its response logic.

This serves as a clean example of a **state-based trigger** — useful for demos, simulations, or more advanced Drosera automations.

---

## 🧩 Components

| Contract | Description |
|-----------|--------------|
| **PasswordTrap.sol** | The main Drosera trap that collects data and determines if it should respond. |
| **PasswordResponse.sol** | A simple example response contract triggered when the trap condition is met. |
| **MockKeyContract.sol** | A mock key storage contract used to simulate password changes on-chain. |

---

## 🧠 Logic Summary

- The trap **monitors** the `getKey()` function from a monitored contract.
- It **hashes** the returned string using `keccak256`.
- It compares the result to a pre-configured `targetHash`.
- If they match, `shouldRespond()` returns `true`.

### Default Configuration
- Default password: `"open-sesame"`
- Default hash: `0x754b1823247e990c20230ca0d8806c29508cc9244c059c09a1869b56ab64dacd`

---

## ⚙️ Deployment

Deploy contracts individually or via a Foundry script:

```bash
forge script script/DeployPasswordTrap.s.sol --rpc-url $HOODI_RPC --broadcast --private-key $ETH_PRIVATE_KEY

```

## Example deployed addresses:
- PasswordTrap       — 0x..............
- PasswordResponse   — 0x..............
- MockKeyContract    — 0x..............
## Configuration (Linking the Trap)
After deploying, link your trap to the monitored key contract and update its password hash:
```
cast send <PasswordTrap.sol> \
  "setKeyContract(address)" <MockKeyContract.sol> \
  --rpc-url $HOODI_RPC --private-key $ETH_PRIVATE_KEY

cast send <PasswordTrap.sol> \
  "setTargetHash(string)" "open-sesame" \
  --rpc-url $HOODI_RPC --private-key $ETH_PRIVATE_KEY
  ```
## Verify your setup
```
cast call <PasswordTrap.sol> "keyContract()" --rpc-url $HOODI_RPC
cast call <PasswordTrap.sol> "targetHash()" --rpc-url $HOODI_RPC
```
## Run the Trap via Drosera
```
drosera dryrun
```
## Expected output
```
 trap_name: password_trap,
    result: TrapResult {
    trapAddress: 0xfcddc0c9130d1a4b11584c17406c4fbee9a487cc,
    shouldRespond: true,
    blockNumber: 1431180,
    blockHash: 0x45b48a60bad476e000604781d68c7282fa9f7aafdf2e66c68abf12e37694b0db,
    responseData: 0x,
    trapHash: 0xc7c57d93e77d6be2964ecc44a028c9283cb76468e598d61ea3481fab13db2e5f,
}
```
## Drosera Integration
Add to your drosera.toml:
```
[traps.password_trap]
address = "<PasswordTrap.sol>"
response_address = "<PasswordResponse.sol>"
collect_interval = "10s"
```
## Then apply it:
```
DROSERA_PRIVATE_KEY=Your_Private_Key drosera apply
```
