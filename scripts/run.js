const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    // Boss
    "Big Kangh", // Boss name
    "https://i.imgur.com/jBQ57F5.png", // Boss image
    10000, // Boss hp
    150, // Boss attack damage
    // Players
    // id
    [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11
    ],
    // name
    [
      'Arrow',
      'Assasin',
      'Blood Elf',
      'Bounty Hunter',
      'Doctor',
      'Fighter',
      'Pirate',
      'Punisher',
      'Samurai',
      'Valquiria',
      'Warrior',
      'Wizard',
    ],    
    // imageURI
    [
      'https://i.imgur.com/FJ5lUgJ.png',
      'https://i.imgur.com/CmYArzl.png',
      'https://i.imgur.com/BvpPiRE.png',
      'https://i.imgur.com/3XGEHQh.png',
      'https://i.imgur.com/v0W6GOD.png',
      'https://i.imgur.com/Ld5Ra2j.png',
      'https://i.imgur.com/Sqa43qp.png',
      'https://i.imgur.com/L2QcAbi.png',
      'https://i.imgur.com/2fC9ewH.png',
      'https://i.imgur.com/pn0iaKf.png',
      'https://i.imgur.com/zT8ObmD.png',
      'https://i.imgur.com/eyG6FgJ.png',
    ],
    // HP values
    [
      1000,
      1000,
      1000,
      1000,
      1000,
      1000,
      1000,
      1000,
      1000,
      1000,
      1000,
      1000,
    ],   
    // Attack damage values                 
    [
      100,
      100,
      100,
      100,
      100,
      100,
      100,
      100,
      100,
      100,
      100,
      100,
    ],
    // shield
    [
      50,
      50,
      50,
      50,
      50,
      50,
      50,
      50,
      50,
      50,
      50,
      50,
    ]                       
  );                    
  
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;
  // Probamos mintCharacterNFT()
  txn = await gameContract.mintCharacterNFT(0);
  txn.wait();

  txn = await gameContract.mintCharacterNFT(1);
  txn.wait();

  txn = await gameContract.mintCharacterNFT(1);
  txn.wait();

  txn = await gameContract.mintCharacterNFT(2);
  txn.wait();

  //> Probamos tokenURI(). Obtenemos el valor de la URI de nuestro NFT.
  let returnedTokenUri = await gameContract.tokenURI(1);
  console.log("Token URI:", returnedTokenUri);

  // Probamos attackBoss() 
  txn = await gameContract.attackBoss();
  await txn.wait();

  txn = await gameContract.attackBoss();
  await txn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();