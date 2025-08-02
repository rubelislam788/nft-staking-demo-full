// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract NFTStaking {
    IERC721 public nft;
    address public owner;

    struct StakeInfo {
        address staker;
        uint256 stakedAt;
        uint256 lastClaimed;
    }

    mapping(uint256 => StakeInfo) public stakes;

    mapping(uint256 => uint256) public rarityRates;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor(address _nft) {
        nft = IERC721(_nft);
        owner = msg.sender;
    }

    function setRarityRate(uint256 tokenId, uint256 rate) external onlyOwner {
        require(rate > 0, "Invalid rate");
        rarityRates[tokenId] = rate;
    }

    function stake(uint256 tokenId) external {
        require(nft.ownerOf(tokenId) == msg.sender, "Not NFT owner");
        nft.transferFrom(msg.sender, address(this), tokenId);
        stakes[tokenId] = StakeInfo({
            staker: msg.sender,
            stakedAt: block.timestamp,
            lastClaimed: block.timestamp
        });
    }

    function unstake(uint256 tokenId) external {
        require(stakes[tokenId].staker == msg.sender, "Not staker");
        claimPoints(tokenId);
        delete stakes[tokenId];
        nft.transferFrom(address(this), msg.sender, tokenId);
    }

    function calculatePoints(uint256 tokenId) public view returns (uint256) {
        StakeInfo memory info = stakes[tokenId];
        require(info.staker != address(0), "Not staked");

        uint256 rate = rarityRates[tokenId];
        require(rate > 0, "Rarity rate not set");

        uint256 elapsed = block.timestamp - info.lastClaimed;
        if (elapsed < 5 minutes) return 0;

        return (rate * elapsed) / 3600;
    }

    function claimPoints(uint256 tokenId) public {
        StakeInfo storage info = stakes[tokenId];
        require(info.staker == msg.sender, "Not staker");

        uint256 points = calculatePoints(tokenId);
        require(points > 0, "Nothing to claim yet");

        info.lastClaimed = block.timestamp;

        emit PointsClaimed(msg.sender, tokenId, points);
    }

    event PointsClaimed(address indexed user, uint256 indexed tokenId, uint256 points);
}
