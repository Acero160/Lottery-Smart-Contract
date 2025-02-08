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
        //Minteamos los tokens al smart contract de la loteria
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
        //Comprobamos que el contrato tenga tokens suficientes
        require (balanceOf(address(this))>= _numTokens, "Not enough tokens");
        
        //Comprobamos que tenga el usuario saldo suficiente para comprar
        uint price = tokenPrice(_numTokens);
        require (msg.value >= price, "Not enough ethers");

        //si pasamos las comprobaciones, ya podemos comprar tokens
        uint returnValue = msg.value - price;
        payable(msg.sender).transfer(returnValue);

        _transfer(address(this), msg.sender, _numTokens);
    }

    function ticketPrice() public returns(uint) {
        return 2;
    }
    
    function buyTicket (uint _numTickets) public {
        //calculamos el precio de los tickets que vaya a comprar
        uint totalPrice = _numTickets*ticketPrice();
        //comprobamos si tiene dinero suficiente
        require(balanceOf(msg.sender)>= totalPrice);

        //Se transfiere los tokens 
        _transfer(msg.sender, address(this), totalPrice);

        //Genera el numero random del ticket(el %10000, es para que nos salga del 1 al 9999(tickets))
        for (uint i=0; i< _numTickets; i++){
            uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, i)))% 10000;
            //Minteamos el ticket
            Tickets(user_contract[msg.sender]).mintTicket(msg.sender, random);
            purchasedTickets.push(random);
            //Asignamos ticket al usuario
            user_ticketID[msg.sender].push(random);
            ticketID_user[random] = msg.sender;
        }
    }

    //Funcion para ver los tickets que tiene cada usuario
    function viewTickets(address _owner) public view returns(uint[]memory) {
        return user_ticketID[_owner];
    }

    function generateWinner() public onlyOwner {
        //comprobamos que el usuario haya comprado tickets
        uint len = purchasedTickets.length;
        require(len > 0, "No tickets purchased");

        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender)))%len;

        //gerenamos ganador
        uint winnerTicket = purchasedTickets[random];
        winnerAddress = ticketID_user[winnerTicket];

        //Damos el 90% del premio al ganador de la loteria, y el 10 por ciento para el owner, 
        //ya que ha sido el que ha realizado el trabajo de la loteria
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
