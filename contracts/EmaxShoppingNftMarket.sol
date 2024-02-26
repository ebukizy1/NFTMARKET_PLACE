// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract NFTMarketplace {
    using SafeMath for uint256;

    struct Listing {
        address seller;
        uint256 price;
        bool isAvailable;
    }

    mapping(uint256 => Listing) public listings;
    mapping(address => uint256[]) public listedTokens;

    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price);

    ERC721 public nft;

    constructor(address _nftAddress) {
        nft = ERC721(_nftAddress);
    }

    function listNFT(uint256 _tokenId, uint256 _price) external {
        require(nft.ownerOf(_tokenId) == msg.sender, "Only the owner can list the NFT");
        require(listings[_tokenId].isAvailable == false, "NFT is already listed");

        listings[_tokenId] = Listing(msg.sender, _price, true);
        listedTokens[msg.sender].push(_tokenId);

        emit NFTListed(_tokenId, msg.sender, _price);
    }

    function buyNFT(uint256 _tokenId) external payable {
        Listing memory listing = listings[_tokenId];
        require(listing.isAvailable, "NFT is not listed for sale");
        require(msg.value >= listing.price, "Insufficient funds");

        address seller = listing.seller;
        listings[_tokenId] = Listing(address(0), 0, false);
        nft.safeTransferFrom(seller, msg.sender, _tokenId);

        payable(seller).transfer(msg.value);

        emit NFTSold(_tokenId, seller, msg.sender, listing.price);
    }

    function getListing(uint256 _tokenId) external view returns (address, uint256, bool) {
        Listing memory listing = listings[_tokenId];
        return (listing.seller, listing.price, listing.isAvailable);
    }

    function getMyListedTokens() external view returns (uint256[] memory) {
        return listedTokens[msg.sender];
    }
}
