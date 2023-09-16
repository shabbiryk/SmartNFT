// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public cost;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialCost
    ) ERC721(_name, _symbol) {
        cost = _initialCost;
    }

    // Mint a new NFT token with the given tokenURI and assign it to the sender
    function mint(string memory tokenURI) external payable {
        require(msg.value >= cost, "Insufficient funds sent"); // Check if sufficient funds are sent

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId); // Mint the NFT and assign it to the sender
        _setTokenURI(newItemId, tokenURI); // Set the tokenURI for the NFT
    }

    // Get the total number of NFTs minted
    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }

    // Set the cost required to mint a new NFT (onlyOwner can update)
    function setCost(uint256 newCost) external onlyOwner {
        cost = newCost;
    }

    // Withdraw contract balance to the owner's address (onlyOwner can call)
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
