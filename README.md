

---

# CryptoLotto - Decentralized Lottery Smart Contract

Welcome to **CryptoLotto**, a decentralized lottery built on Ethereum using smart contracts. This project leverages blockchain technology to create a transparent, secure, and trustless lottery system. Users can participate in the lottery by purchasing tokens, which are used to buy tickets. The lottery is fully automated, ensuring fairness and transparency in drawing the winner.

## 🚀 Features

- **Decentralized Ownership**: The contract is owned by a decentralized smart contract system with transparent governance.
- **Token Integration**: Use the native ERC20 token (CryptoLotto token) to buy tickets and participate in the lottery.
- **NFT Ticketing**: Each lottery ticket is minted as an NFT, providing proof of purchase and allowing for a secure, traceable experience.
- **Fair Randomization**: Winning ticket selection is based on a secure, randomized process using the blockchain, ensuring fairness and transparency.
- **Automatic Payouts**: The smart contract automatically transfers 90% of the prize pool to the winner, with the remaining 10% going to the contract owner.

## 🛠️ Technologies Used

- **Solidity**: Smart contract programming language.
- **ERC20 & ERC721**: Ethereum token standards for fungible tokens (CryptoLotto tokens) and non-fungible tokens (NFT tickets).
- **OpenZeppelin**: Secure and community-vetted contract library.

## 📦 Installation & Setup

1. Clone the repository:

```bash
git clone https://github.com/yourusername/lottery-smart-contract.git
cd lottery-smart-contract
```

2. Install dependencies:

```bash
npm install
```

3. Deploy the contracts on the Ethereum testnet (Rinkeby, Ropsten, etc.) using Truffle or Hardhat.

4. Interact with the smart contract via web3.js or ethers.js, or integrate it into your decentralized application (DApp).

## 📝 How It Works

### Factory Contract

- The **Factory contract** allows users to deploy their own lottery contract. Each user can create a new instance of the lottery contract using the factory, providing them with a unique address to manage their lottery system.

### Lottery Contract

- The **Lottery contract** is the core of the lottery system. It allows users to:
  - Buy **CryptoLotto tokens** using ETH.
  - Purchase **NFT tickets** by exchanging tokens.
  - Participate in the lottery with a chance to win the prize pool.
  - View their purchased tickets and claim winnings.

The lottery contract also contains functions to:
  - **Generate a winner** based on a secure random number.
  - Automatically transfer the prize to the winner and a small percentage to the contract owner.

### NFT Ticketing

- Each ticket is represented as an ERC721 NFT, which provides secure ownership of the ticket.
- The **NFT contract** ensures that only the correct lottery contract can mint and assign tickets to users.

### Prize Distribution

- The winner receives **90%** of the total funds collected, and the **contract owner** gets **10%**.
- This distribution happens automatically upon the generation of a winner.

## 🧑‍💻 Smart Contract Structure

The smart contracts include the following key components:

1. **Factory.sol**: Creates new instances of lottery contracts for users.
2. **Lottery.sol**: Main contract handling ticket purchases, winner selection, and prize distribution.
3. **NFTs.sol**: ERC721 contract for minting and managing NFT tickets.
4. **Tickets.sol**: Handles minting and managing individual tickets.

## 🎯 How to Use

1. **Buy Tokens**: Users can purchase CryptoLotto tokens by sending ETH to the contract. The tokens can then be used to buy tickets.
2. **Buy Tickets**: Users can buy tickets with CryptoLotto tokens, each ticket represented as an NFT.
3. **Generate a Winner**: The contract owner can call the `generateWinner` function to select the winner randomly. The winner receives 90% of the total funds in the contract.

## 📈 Security Features

- **Ownership control**: The owner has full control over the lottery contract, including generating the winner and managing the prize distribution.
- **Randomness**: The ticket selection and winner generation are based on a secure random number generated using block data.
- **ERC20 Compliance**: The CryptoLotto token is ERC20 compliant, ensuring compatibility with various wallets and exchanges.

## 🔍 Future Improvements

- **Multi-Lottery Support**: Allow users to create and participate in multiple lottery pools simultaneously.
- **Ticket Market**: Implement a secondary marketplace for users to sell or transfer their NFT tickets.
- **More Prizes**: Introduce additional prizes and reward tiers for more lottery excitement.

## 🤝 Contributing

We welcome contributions to make CryptoLotto even better. If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This `README.md` offers a professional, clear explanation of your project, outlining the smart contract’s purpose, its components, and how others can use and contribute to it. It’s designed to attract the attention of recruiters by showing a practical implementation of blockchain technology and good code organization.
