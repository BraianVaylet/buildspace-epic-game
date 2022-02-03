const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
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
  txn = await gameContract.mintCharacterNFT(0);
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #2");

  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();
  console.log("Minted NFT #3");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #4");

  console.log("Done deploying and minting!");

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