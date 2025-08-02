# NFT Staking Demo (Monad-Compatible)

This is a full demo project for NFT staking and point earning on Monad chain.

## 🧱 Components

- **Smart Contract (Solidity):**
  - Stake NFT
  - Claim points based on rarity
  - 5-minute claim cooldown

- **Frontend (React + Vite + Ethers.js):**
  - Wallet Connect
  - Stake/Unstake buttons
  - Claim Points
  - Display rarity and earning rate

## 🚀 How to Run

### 1. Smart Contract

Deploy `NFTStaking.sol` on Remix or Hardhat (Monad EVM-compatible environment). Set `setRarityRate(tokenId, rate)` after minting NFT.

### 2. Frontend

```bash
cd frontend
npm install
npm run dev
```

Open in browser: [http://localhost:5173](http://localhost:5173)

Then, replace `CONTRACT_ADDRESS` inside `App.jsx` with your deployed contract address.

## 🏆 Rarity Point Rates (/hour)

- Common: 100
- Uncommon: 200
- Rare: 600
- Epic: 700
- Legendary: 1000

## ⚠️ Note

- This is a demo. In production, you would use real NFT metadata, backend points, and proper signature verifications.
