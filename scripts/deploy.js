const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    // Boss
    "Big Kangh", // Boss name
    "https://i.imgur.com/jBQ57F5.png", // Boss image
    10000, // Boss hp
    150, // Boss attack damage
    // Players
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
      1500,
      1500,
      1500,
      1500,
      1500,
      1500,
      1500,
      1500,
      1500,
      1500,
      1500,
      1500,
    ],   
    // Attack damage values                 
    [
      150,
      150,
      200,
      100,
      50,
      100,
      50,
      150,
      100,
      50,
      150,
      50,
    ],
    // shield
    [
      50,
      50,
      0,
      100,
      150,
      100,
      150,
      50,
      100,
      150,
      50,
      150,
    ]                       
  );                    
  
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);
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