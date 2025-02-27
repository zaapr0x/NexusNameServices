// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NexusNameService is ERC721URIStorage, Ownable {
    struct Domain {
        address owner;
        uint256 expires;
    }
    
    mapping(string => Domain) public domains;
    mapping(address => string) public reverseLookup;
    string[] public registeredNames;
    uint256 public constant BASE_FEE = 0.01 ether;
    uint256 public constant FEE_1_CHAR = 0.1 ether;
    uint256 public constant FEE_2_CHAR = 0.01 ether;
    uint256 public constant FEE_3_CHAR = 0.001 ether;
    uint256 public constant FEE_4_CHAR = 0.0005 ether;
    uint256 public constant FEE_5_PLUS_CHAR = 0.00025 ether;
    uint256 public constant REGISTRATION_PERIOD = 365 days;
    uint256 private _tokenIdCounter;

    event NameRegistered(string indexed name, address indexed owner, uint256 expires);
    event NameTransferred(string indexed name, address indexed newOwner);
    event NameRenewed(string indexed name, uint256 newExpiration);

    constructor(address initialOwner) ERC721("NexusNameService", "NNS") Ownable(initialOwner) {}

    modifier onlyOwnerOf(string memory name) {
        require(domains[name].owner == msg.sender, "Not the owner");
        _;
    }

    function getRegistrationFee(string memory name) public pure returns (uint256) {
        uint256 length = bytes(name).length;
        if (length == 1) return FEE_1_CHAR;
        if (length == 2) return FEE_2_CHAR;
        if (length == 3) return FEE_3_CHAR;
        if (length == 4) return FEE_4_CHAR;
        return FEE_5_PLUS_CHAR;
    }

    function registerName(string memory name, string memory imageUrl) external payable {
        require(bytes(name).length > 0, "Invalid name");
        require(domains[name].owner == address(0), "Name already taken");
        uint256 fee = getRegistrationFee(name);
        require(msg.value >= fee, "Insufficient fee");
        
        uint256 expires = block.timestamp + REGISTRATION_PERIOD;
        domains[name] = Domain({ owner: msg.sender, expires: expires });
        reverseLookup[msg.sender] = name;
        registeredNames.push(name);
        
        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;
        _mint(msg.sender, newTokenId);
        
        string memory metadata = string(
            abi.encodePacked(
                '{"name": "', name, '", ',
                '"description": "Nexus Name Service NFT for ', name, '", ',
                '"image": "', imageUrl, '", ',
                '"attributes": [{"trait_type": "Expires", "value": "', uint2str(expires), '"}]}'
            )
        );
        
        _setTokenURI(newTokenId, metadata);
        
        emit NameRegistered(name, msg.sender, expires);
    }

    function transferName(string memory name, address newOwner) external onlyOwnerOf(name) {
        require(newOwner != address(0), "Invalid address");
        
        domains[name].owner = newOwner;
        reverseLookup[newOwner] = name;
        
        emit NameTransferred(name, newOwner);
    }
    
    function renewName(string memory name) external payable onlyOwnerOf(name) {
        uint256 fee = getRegistrationFee(name);
        require(msg.value >= fee, "Insufficient fee");
        
        domains[name].expires += REGISTRATION_PERIOD;
        
        emit NameRenewed(name, domains[name].expires);
    }

    function resolveName(string memory name) external view returns (address) {
        require(domains[name].expires > block.timestamp, "Domain expired");
        return domains[name].owner;
    }

    function getMyName() external view returns (string memory) {
        return reverseLookup[msg.sender];
    }

    function getAllRegisteredNames() external view returns (string[] memory) {
        return registeredNames;
    }

    function getDomainInfo(string memory name) external view returns (address owner, uint256 expires, string memory explorerUrl) {
        require(domains[name].owner != address(0), "Domain not found");
        return (domains[name].owner, domains[name].expires, string(abi.encodePacked("https://explorer.nexus.xyz/domain/", name)));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        while (_i != 0) {
            bstr[--length] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
