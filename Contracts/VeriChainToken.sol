// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VeriChainToken is ERC721URIStorage {
    
    address owner;

    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;

    constructor() ERC721("VeriChainToken", "Cert") {
        owner = msg.sender;
    }
    
    mapping(address => bool) public issuedCerts;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function issuedCert(address to) onlyOwner external {
        issuedCerts[to] = true;
    }

    function claimCert(string memory tokenURI) public returns(uint256) {
        require(issuedCerts[msg.sender], "Certificate is not issued");

        tokenIds.increment();
        uint256 newItemId = tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        personToCert[msg.sender] = tokenURI;
        issuedCerts[msg.sender] = false;

        return newItemId;
    }

    mapping(address => string) public personToCert;

    
}