// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PookieHampersNFT
 * @dev NFT loyalty program for Pookie Hampers customers
 * Customers can earn and redeem digital collectibles for purchases
 */

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PookieHampersNFT is ERC721, Ownable {
    // =============================================================================
    // STATE VARIABLES
    // =============================================================================

    uint256 private tokenIdCounter = 0;
    
    // Pookie tier system
    enum PookieTier {
        BRONZE,
        SILVER,
        GOLD,
        PLATINUM
    }

    struct PookieNFT {
        uint256 tokenId;
        string name;
        PookieTier tier;
        uint256 purchaseCount;
        uint256 totalSpent;
        uint256 createdAt;
        bool isStaked;
    }

    // Token to NFT metadata
    mapping(uint256 => PookieNFT) public nfts;
    mapping(address => uint256[]) public userNFTs;
    mapping(address => bool) public isMinter;

    // Loyalty rewards
    mapping(PookieTier => uint256) public tierRewards;
    mapping(address => uint256) public pendingRewards;

    // Constants
    uint256 public constant BRONZE_THRESHOLD = 5000; // 50 INR in wei
    uint256 public constant SILVER_THRESHOLD = 15000;
    uint256 public constant GOLD_THRESHOLD = 50000;
    uint256 public constant PLATINUM_THRESHOLD = 100000;

    // Events
    event PookieCreated(address indexed owner, uint256 indexed tokenId, PookieTier tier);
    event TierUpgraded(address indexed owner, uint256 indexed tokenId, PookieTier newTier);
    event RewardsClaimed(address indexed owner, uint256 amount);
    event Staked(address indexed owner, uint256 indexed tokenId);
    event Unstaked(address indexed owner, uint256 indexed tokenId);

    // =============================================================================
    // CONSTRUCTOR
    // =============================================================================

    constructor() ERC721("Pookie Hampers Loyalty", "POOKIE") {
        // Initialize tier rewards (in wei)
        tierRewards[PookieTier.BRONZE] = 1000;
        tierRewards[PookieTier.SILVER] = 2500;
        tierRewards[PookieTier.GOLD] = 5000;
        tierRewards[PookieTier.PLATINUM] = 10000;
    }

    // =============================================================================
    // MINTING
    // =============================================================================

    /**
     * @dev Create a new Pookie NFT for customer
     * @param to Address to mint NFT to
     * @param name Customer's pookie name
     */
    function mintPookie(address to, string memory name) public onlyMinter {
        uint256 tokenId = tokenIdCounter++;
        _safeMint(to, tokenId);

        nfts[tokenId] = PookieNFT({
            tokenId: tokenId,
            name: name,
            tier: PookieTier.BRONZE,
            purchaseCount: 1,
            totalSpent: 0,
            createdAt: block.timestamp,
            isStaked: false
        });

        userNFTs[to].push(tokenId);
        emit PookieCreated(to, tokenId, PookieTier.BRONZE);
    }

    /**
     * @dev Record a purchase and update NFT tier
     * @param owner Customer address
     * @param amount Purchase amount in wei
     */
    function recordPurchase(address owner, uint256 amount) public onlyMinter {
        if (userNFTs[owner].length == 0) {
            mintPookie(owner, "Pookie");
        }

        uint256 tokenId = userNFTs[owner][0];
        PookieNFT storage pookie = nfts[tokenId];

        pookie.purchaseCount += 1;
        pookie.totalSpent += amount;

        // Check for tier upgrade
        PookieTier newTier = calculateTier(pookie.totalSpent);
        if (newTier > pookie.tier) {
            pookie.tier = newTier;
            pendingRewards[owner] += tierRewards[newTier];
            emit TierUpgraded(owner, tokenId, newTier);
        }
    }

    // =============================================================================
    // TIER SYSTEM
    // =============================================================================

    /**
     * @dev Calculate tier based on total spending
     */
    function calculateTier(uint256 totalSpent) public pure returns (PookieTier) {
        if (totalSpent >= PLATINUM_THRESHOLD) return PookieTier.PLATINUM;
        if (totalSpent >= GOLD_THRESHOLD) return PookieTier.GOLD;
        if (totalSpent >= SILVER_THRESHOLD) return PookieTier.SILVER;
        return PookieTier.BRONZE;
    }

    /**
     * @dev Get user's primary Pookie NFT
     */
    function getUserPookie(address user) public view returns (PookieNFT memory) {
        require(userNFTs[user].length > 0, "No Pookie NFT found");
        return nfts[userNFTs[user][0]];
    }

    // =============================================================================
    // REWARDS & STAKING
    // =============================================================================

    /**
     * @dev Claim pending rewards
     */
    function claimRewards() public {
        uint256 amount = pendingRewards[msg.sender];
        require(amount > 0, "No pending rewards");

        pendingRewards[msg.sender] = 0;
        emit RewardsClaimed(msg.sender, amount);

        // Note: Actual token transfer would be implemented here
        // This is a placeholder for the reward mechanism
    }

    /**
     * @dev Stake NFT for additional rewards
     */
    function stakeNFT(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        nfts[tokenId].isStaked = true;
        emit Staked(msg.sender, tokenId);
    }

    /**
     * @dev Unstake NFT
     */
    function unstakeNFT(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        nfts[tokenId].isStaked = false;
        emit Unstaked(msg.sender, tokenId);
    }

    // =============================================================================
    // ADMIN
    // =============================================================================

    /**
     * @dev Grant minter role (for order processing contract)
     */
    function setMinter(address minter, bool status) public onlyOwner {
        isMinter[minter] = status;
    }

    /**
     * @dev Check if caller is minter
     */
    modifier onlyMinter() {
        require(isMinter[msg.sender] || msg.sender == owner(), "Not minter");
        _;
    }

    /**
     * @dev Update tier rewards
     */
    function setTierReward(PookieTier tier, uint256 amount) public onlyOwner {
        tierRewards[tier] = amount;
    }

    /**
     * @dev Get all user NFTs
     */
    function getUserNFTs(address user) public view returns (uint256[] memory) {
        return userNFTs[user];
    }

    /**
     * @dev Token URI (metadata)
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        PookieNFT memory pookie = nfts[tokenId];
        
        // Construct metadata URI (points to IPFS or server)
        return string(abi.encodePacked("ipfs://QmPookie/", _toString(tokenId)));
    }

    /**
     * @dev Helper function to convert uint to string
     */
    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
