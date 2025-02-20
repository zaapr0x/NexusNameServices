## Nexus Name Service (NNS)

Nexus Name Service (NNS) is a decentralized domain name service built on the blockchain. Users can register, transfer, and manage domain names as NFTs.

### Features
- **Domain Registration**: Users can register a unique domain name.
- **Ownership Transfer**: Domains can be transferred to other users.
- **Renewal System**: Domains can be renewed before expiration.
- **Reverse Lookup**: Resolve addresses back to domain names.
- **NFT Representation**: Domains are represented as ERC-721 NFTs.

---

## Installation

### Prerequisites
Ensure you have the following installed:
- [Node.js](https://nodejs.org/)
- [Hardhat](https://hardhat.org/)
- A wallet like [MetaMask](https://metamask.io/)

### Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/NexusNameService.git
   cd NexusNameService
   ```
2. Install dependencies:
   ```sh
   npm install
   ```

---

## Configuration

Create a `.env` file in the project root and add:

```
RPC_URL=YOUR_RPC_URL
PRIVATE_KEY=YOUR_PRIVATE_KEY
```

Update `hardhat.config.js` with your blockchain network details.

---

## Deployment

To deploy the contract, run:

```sh
npx hardhat run scripts/deploy.js --network nexus
```

After deployment, note the contract address for verification.

---

## Verification

To verify the contract on BlockScout:

```sh
npx hardhat verify --network nexus CONTRACT_ADDRESS "ARGUMENT_1" "ARGUMENT_2"
```

---

## Testing

To run tests:

```sh
npx hardhat test
```

---

## Usage

### Register a Domain
Call the `registerName` function by sending the required fee.

### Transfer a Domain
Use the `transferName` function with the recipient's address.

### Renew a Domain
Call `renewName` before expiration.

---

## License

This project is licensed under the **MIT License**.

