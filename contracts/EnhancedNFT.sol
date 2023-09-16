// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract AdvancedNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public cost;
    uint256 public maxTokens;
    uint256 public maxMintsPerUser;
    mapping(address => uint256) public userMintCounts;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _cost,
        uint256 _maxTokens,
        uint256 _maxMintsPerUser
    ) ERC721(_name, _symbol) {
        cost = _cost;
        maxTokens = _maxTokens;
        maxMintsPerUser = _maxMintsPerUser;
    }

    function mint(string memory tokenURI) public payable {
        require(msg.value >= cost, "Insufficient payment.");
        require(totalSupply() < maxTokens, "Maximum token limit reached.");
        require(userMintCounts[msg.sender] < maxMintsPerUser, "Maximum mints per user reached.");

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        userMintCounts[msg.sender]++;
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    function setMintingCost(uint256 newCost) public onlyOwner {
        cost = newCost;
    }

    function setMaxTokens(uint256 newMaxTokens) public onlyOwner {
        maxTokens = newMaxTokens;
    }

    function setMaxMintsPerUser(uint256 newMaxMints) public onlyOwner {
        maxMintsPerUser = newMaxMints;
    }

    function withdrawBalance() public onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Withdrawal failed.");
    }
}
