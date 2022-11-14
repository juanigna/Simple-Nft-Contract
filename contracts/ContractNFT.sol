pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleMintContract is ERC721, Ownable{
    uint256 public mintPrice = 5 ether;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public isMintEnabled;
    mapping(address => uint256) public mintedWallets;

    constructor() payable ERC721("SimpleMint", "MINT"){
        maxSupply = 2;
    } 

    function toggleIsMintedEnable() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }

    function mint()external payable{
        require(isMintEnabled, "Minted is not enabled");
        require(msg.value == mintPrice, "Wrong value of ETH");
        require(maxSupply > totalSupply, "Out of stock");

        mintedWallets[msg.sender]++;
        totalSupply++;

        uint tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);
        
    }

    function Withdraw() external payable onlyOwner{
        require(address(this).balance > 0 ether, "This contract doesnt have money!");
        payable(msg.sender).transfer(address(this).balance);
    }
}   