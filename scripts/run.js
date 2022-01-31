
const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    // name
    [
      'Artemisa',
      'Bula',
      'Castiel',
      'Ilaisa',
      'Charlie',
      'Merlin',
      'Monica',
      'Nova',
      'Pyro',
      'Vanesa',
      'Tuk',
    ],    
    // imageURI
    [
      'https://i.imgur.com/4BENzkp.png',
      'https://i.imgur.com/3rtDSEx.png',
      'https://i.imgur.com/70cqAfp.png',
      'https://i.imgur.com/cS33BLP.png',
      'https://i.imgur.com/19JaC3R.png',
      'https://i.imgur.com/ncrKsWW.png',
      'https://i.imgur.com/0LoxW5b.png',
      'https://i.imgur.com/Nu9jkT7.png',
      'https://i.imgur.com/iuAqwmG.png',
      'https://i.imgur.com/9mLm29q.png',
      'https://i.imgur.com/iIMC6Fl.png',
    ],
    // HP values
    [
      1500,
      2000,
      1000,
      500,
      1500,
      1500,
      1500,
      1200,
      500,
      1500,
      1000,
    ],   
    // Attack damage values                 
    [
      400,
      200,
      1000,
      1000,
      300,
      500,
      600,
      600,
      1500,
      100,
      1000,
      1000,
    ],
    // shield
    [
      600,
      300,
      500,
      1000,
      700,
      500,
      400,
      700,
      500,
      900,
      500,
      1000,
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