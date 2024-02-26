
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract EmaxShoopingNFTMarketplace is ERC721,Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    error CALLER_NOT_AUTHORIZED();
    error INVALID_MINTERS_ADDRESS(); 

    struct EmaxProductNFT {
        uint256 id;
        address creator;
        string imageUrl;
        uint256 price;
        bool forSale;
    }


    mapping(uint256 => EmaxProductNFT) private productNFTs;
    mapping(address => bool) private authorizedMinters;

    constructor() ERC721("VideoNFT", "VNFT") {}

    modifier onlyMinter() {
        if(!authorizedMinters[msg.sender]){
            revert CALLER_NOT_AUTHORIZED();
        }
        _;
    }

    function addMinter(address _minter) external onlyMinter {
       addressZeroCheck(_minter);
        authorizedMinters[_minter] = true;
    }

    function removeMinter(address _minter) external onlyMinter{
            addressZeroCheck(_minter);
        authorizedMinters[_minter] = false;
    }

    function mintProductNFT(string memory _imageUrl, uint256 _price) external onlyMinter {
        _tokenIds.increment();
        uint256 newNFTId = _tokenIds.current();
        _mint(msg.sender, newNFTId);

        EmaxProductNFT  memory _newProductNFT = EmaxProductNFT({
            id: newNFTId,
            creator: msg.sender,
            imageUrl: _imageUrl,
            price: _price,
            forSale: false
        });

        productNFTs[newNFTId] = _newProductNFT;
    }

    function buyProductNFT(uint256 _tokenId) external payable {
         EmaxProductNFT  storage nft = productNFTs[_tokenId];
        require(nft.forSale == true, "NFT is not for sale");
        require(msg.value >= nft.price, "Insufficient funds");

        address payable seller = payable(ownerOf(_tokenId));
        seller.transfer(msg.value);

        _transfer(seller, msg.sender, _tokenId);
        nft.forSale = false;
    }

    function sellNFT(uint256 _tokenId, uint256 _price) external {
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner of this NFT");

       EmaxProductNFT storage nft = productNFTs[_tokenId];
        require(!nft.forSale, "NFT is already for sale");

        nft.price = _price;
        nft.forSale = true;
    }

    function getNFT(uint256 _tokenId) external view returns (uint256, address, string memory, uint256, bool) {
        EmaxProductNFT memory nft = productNFTs[_tokenId];
        return (nft.id, nft.creator, nft.imageUrl, nft.price, nft.forSale);
    }

    function addressZeroCheck(address _minter) private pure {
         if(_minter == address(0)){
                revert INVALID_MINTERS_ADDRESS(); 
         }
    }
}