Contract Overview
ERC721 Token
This contract inherits from the ERC721 standard, providing functionalities for creating and managing unique NFTs.

Minters Management
The contract includes a minter management system, allowing only authorized addresses to mint new NFTs.

NFT Minting
Authorized minters can create new NFTs with associated metadata, such as an image URL and price.

NFT Buying and Selling
Users can buy and sell product NFTs using Ethereum. The contract supports setting NFTs for sale, buying NFTs, and updating sale prices.

Usage
Add Minter
Authorized users can add a new minter address to grant minting privileges.

solidity
Copy code
function addMinter(address _minter) external onlyMinter {
    // Add a new minter
}
Remove Minter
Authorized users can remove a minter address to revoke minting privileges.

solidity
Copy code
function removeMinter(address _minter) external onlyMinter {
    // Remove a minter
}
Mint Product NFT
Authorized minters can create new product NFTs with associated metadata.

solidity
Copy code
function mintProductNFT(string memory _imageUrl, uint256 _price) external onlyMinter {
    // Mint a new product NFT
}
Buy Product NFT
Users can buy product NFTs with Ethereum.

solidity
Copy code
function buyProductNFT(uint256 _tokenId) external payable {
    // Buy a product NFT
}
Sell NFT
NFT owners can set their NFTs for sale or update the sale price.

solidity
Copy code
function sellNFT(uint256 _tokenId, uint256 _price) external {
    // Set NFT for sale or update sale price
}
Get NFT Details
Retrieve details of a specific NFT.

solidity
Copy code
function getNFT(uint256 _tokenId) external view returns (uint256, address, string memory, uint256, bool) {
    // Get NFT details
}
