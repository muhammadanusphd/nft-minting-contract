# NFT Minting Contract (Minimal ERC-721 style)

A minimal, self-contained NFT (ERC-721-like) smart contract for learning and demo purposes.  
Provides minting, ownership, approvals, transfers, and tokenURI metadata storage.

**Important:** This is a simplified implementation for education and demos. Do not use on mainnet without security review and comprehensive testing.

---

## Repo contents

- `NFTMint.sol` — Solidity contract (Solidity ^0.8.0)
- `.gitignore` — basic ignores
- `LICENSE` — MIT

---

## Features

- Mint new NFTs with `mint(address to, string tokenURI)`
- Query owner with `ownerOf(tokenId)`
- Check balance with `balanceOf(address)`
- Transfer tokens with `transferFrom(from, to, tokenId)`
- Approve single-token and operator approvals
- Read metadata with `tokenURI(tokenId)`
- `totalMinted()` shows how many tokens were minted

---

## How to test in Remix (fast)

1. Open https://remix.ethereum.org  
2. Create new file `NFTMint.sol` and paste the code above  
3. Solidity Compiler: choose version `0.8.x` and compile  
4. Deploy & Run Transactions:
   - Environment: `Remix VM (London)` (in-browser)
   - Contract: `NFTMint`
   - Click `Deploy`
5. Expand Deployed Contract

### Mint a token
- Call `mint(to, tokenURI)`  
  Example `to`: pick one of Remix accounts (e.g. `0x5B38...`)  
  Example `tokenURI`: `"https://example.com/metadata/1.json"`
- Note returned tokenId (1, 2, ...)

### Check owner and metadata
- `ownerOf(1)` → returns owner address
- `tokenURI(1)` → returns metadata URI
- `balanceOf(owner)` → returns number of tokens owned

### Transfer
- From the owner account, call `approve(spender, tokenId)` or use `transferFrom(from, to, tokenId)` directly
- To test `transferFrom` from another account: first use `approve(spender, tokenId)` then switch account and call `transferFrom`

---

## Metadata format (example JSON)
NFT metadata is usually hosted as JSON. Example:
```json
{
  "name": "My First NFT",
  "description": "Demo NFT by Muhammad",
  "image": "https://example.com/images/1.png"
}
