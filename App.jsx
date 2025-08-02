import { useEffect, useState } from "react";
import { ethers } from "ethers";
import abi from "./abi/NFTStaking.json";
import "./App.css";

const CONTRACT_ADDRESS = "0xYourContractAddress";

function App() {
  const [wallet, setWallet] = useState(null);
  const [contract, setContract] = useState(null);

  const dummyNFTs = [
    { tokenId: 1, rarity: "Common", rate: 100 },
    { tokenId: 2, rarity: "Legendary", rate: 1000 },
    { tokenId: 3, rarity: "Rare", rate: 600 }
  ];

  useEffect(() => {
    if (window.ethereum) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const stakingContract = new ethers.Contract(CONTRACT_ADDRESS, abi, signer);
      setContract(stakingContract);
    }
  }, []);

  const connectWallet = async () => {
    const accounts = await window.ethereum.request({ method: "eth_requestAccounts" });
    setWallet(accounts[0]);
  };

  const claimPoints = async (tokenId) => {
    try {
      const tx = await contract.claimPoints(tokenId);
      await tx.wait();
      alert(`Claimed for token #${tokenId}`);
    } catch (err) {
      alert("Claim failed");
    }
  };

  return (
    <div className="container">
      <h1>NFT Staking Demo</h1>
      {!wallet ? (
        <button onClick={connectWallet}>Connect Wallet</button>
      ) : (
        <p>Connected: {wallet}</p>
      )}

      <div className="nfts">
        {dummyNFTs.map((nft) => (
          <div key={nft.tokenId} className="nft-card">
            <p>NFT #{nft.tokenId}</p>
            <p>Rarity: {nft.rarity}</p>
            <p>Rate: {nft.rate} pts/hr</p>
            <button onClick={() => claimPoints(nft.tokenId)}>Claim</button>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
