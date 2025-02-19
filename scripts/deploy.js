const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log(`Deploying contract with account: ${deployer.address}`);

    const NexusNameService = await hre.ethers.getContractFactory("NexusNameService");
    const nexusNameService = await NexusNameService.deploy(deployer.address); // Tambahkan initialOwner

    await nexusNameService.waitForDeployment(); // Hardhat V6 tidak pakai `.deployed()`

    console.log(`✅ Nexus Name Service deployed at: ${await nexusNameService.getAddress()}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
