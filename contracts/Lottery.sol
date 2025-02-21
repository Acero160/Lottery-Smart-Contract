// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is ERC20, Ownable {

    //Variables
    address public nft;
    address public winnerAddress;

    //Mappings
    mapping (address => address) user_contract;

    mapping(address => uint[]) user_ticketID;
    mapping(uint => address) ticketID_user;

    uint[] purchasedTickets;


    constructor() ERC20("CryptoLotto", "CRLTT") Ownable (msg.sender) {
        // Mint tokens to the lottery smart contract
        _mint(address(this), 10000);
        nft = address(new NFTs());
    }


    //Functions
    function tokenPrice(uint256 _numTokens) internal pure returns (uint) {
        return _numTokens*0.5 ether;
    } 

    function mint (uint _numTokens) public onlyOwner {
        _mint(address(this), _numTokens);
    }

    function userRegister() internal {
        address secondContract = address (new Tickets(msg.sender, address(this), nft));
        user_contract[msg.sender] = secondContract;
    }

    function usersInfo (address _user) public view returns (address) {
        return user_contract[_user];
    }

    function buyTokensERC20(uint _numTokens) public payable {
        if(user_contract[msg.sender] == address(0)){
            userRegister();
        }
        //Check that the contract has enough tokens
        require (balanceOf(address(this))>= _numTokens, "Not enough tokens");
        
        // Check that the user has enough balance to purchase
        uint price = tokenPrice(_numTokens);
        require (msg.value >= price, "Not enough ethers");

        // If the checks pass, we can proceed to purchase tokens
        uint returnValue = msg.value - price;
        payable(msg.sender).transfer(returnValue);

        _transfer(address(this), msg.sender, _numTokens);
    }

    function ticketPrice() public returns(uint) {
        return 2;
    }
    
    function buyTicket (uint _numTickets) public {
        // Calculate the price of the tickets the user is going to purchase
        uint totalPrice = _numTickets*ticketPrice();
        //Check if the user has enough money
        require(balanceOf(msg.sender)>= totalPrice);

        // Tokens are transferred
        _transfer(msg.sender, address(this), totalPrice);

        // Generates the random number for the ticket (the %10000 is to ensure it ranges from 1 to 9999 (tickets))
        for (uint i=0; i< _numTickets; i++){
            uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, i)))% 10000;
            //Mint token
            Tickets(user_contract[msg.sender]).mintTicket(msg.sender, random);
            purchasedTickets.push(random);
            // Assign the ticket to the user
            user_ticketID[msg.sender].push(random);
            ticketID_user[random] = msg.sender;
        }
    }

    // Function to see the tickets each user has
    function viewTickets(address _owner) public view returns(uint[]memory) {
        return user_ticketID[_owner];
    }

    function generateWinner() public onlyOwner {
        // Check if the user has purchased tickets
        uint len = purchasedTickets.length;
        require(len > 0, "No tickets purchased");

        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender)))%len;

        //Generate winner
        uint winnerTicket = purchasedTickets[random];
        winnerAddress = ticketID_user[winnerTicket];

        //We give 90% of the prize to the lottery winner and 10% to the owner,  
        // as the owner has been the one to organize the lottery
        payable(winnerAddress).transfer(address(this).balance*90/100);
        payable(owner()).transfer(address(this).balance);
    }
}



contract  NFTs is ERC721 {
    address public lotteryContract;
    constructor() ERC721("CyptoLottoTicket", "TCCRLTT"){
        lotteryContract = msg.sender;
    }

    function safeMint(address _owner, uint _ticketID) public {
        require(msg.sender == Lottery(lotteryContract).usersInfo(_owner), "You dont have acces");
        _safeMint(_owner, _ticketID);
    }

}


contract Tickets {
    struct Data {
        address owner;
        address lotteryContract;
        address NFTContract;
        address userContract;
    }


    Data public userData;

    constructor(address _owner, address _lotteryContract, address _NFTContract) {
        userData = Data (_owner, _lotteryContract, _NFTContract, address(this));
    }

     function mintTicket (address _owner, uint _ticketID) public {
        require(msg.sender == userData.lotteryContract, "You dont have permissions");
        NFTs(userData.NFTContract).safeMint(_owner, _ticketID);
    }

}
