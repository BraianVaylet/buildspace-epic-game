// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//> NFT contract.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//> Auxiliares de OpenZeppelin.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//> Auxiliar para Base64
import {Base64} from "./libraries/Base64.sol";

import "hardhat/console.sol";

//> Nuestro contrato hereda el ERC721 de OpenZeppelin el cual respeta el estandar.
contract MyEpicGame is ERC721 {
    //> Hacemos uso de un struct para manter los atributos de nuestro personaje.
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
        uint256 shield;
    }

    //> Hacemos uso de un struct para manter los atributos de nuestro gran jefe.
    struct BigBoss {
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    //> bigBoss sera una variable publica para que podamos hacer referencia al jefe en diferentes funciones.
    BigBoss public bigBoss;

    //> El tokenId es el identificador unico del NFTs, es un numero que va del 0, 1, 2, 3, etc.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //> Array donde guardamos los personajes default
    CharacterAttributes[] defaultCharacters;

    // Creamos una variable de estado como un map a partir del tokenId del nft con los atributos del NFT.
    // nftHolderAttributes será donde almacenaremos el estado de los NFT del jugador.
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    mapping(uint256 => CharacterAttributes) public defaultAttributes;
    //> Creamos otra variable de estado como un map desde una dirección con el tokenId del NFT.
    // Esto me da una manera simple de almacenar el propietario del NFT y referenciarlo más tarde.
    mapping(address => uint256) public nftHolders;

    //> Eventos
    event CharacterNFTMinted(
        address sender,
        uint256 tokenId,
        uint256 characterIndex
    );
    event AttackComplete(uint256 newBossHp, uint256 newPlayerHp);

    //> Datos pasados ​​al contrato cuando se crea por primera vez inicializandolos
    // vamos a pasar estos valores desde run.js.
    // Tambien agrego un nuevo nombre y símbolo para nuestro token ERC721.
    constructor(
        //> Gran Jefe
        string memory bossName,
        string memory bossImageURI,
        uint256 bossHp,
        uint256 bossAttackDamage,
        //> Personajes
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        uint256[] memory characterShield
    ) ERC721("Heroes", "HERO") {
        // > Inicializamos nuestro Jefe y lo guardamos en la variable global 'bigBoss'
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });
        console.log(
            "Done initializing boss %s w/ HP %s, img %s",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.imageURI
        );

        //> Recorremos todos los caracteres y guardamos sus valores en nuestro contrato para que
        // podemos usarlos más tarde cuando acuñamos nuestros NFT.
        for (uint256 i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    hp: characterHp[i],
                    maxHp: characterHp[i],
                    attackDamage: characterAttackDmg[i],
                    shield: characterShield[i]
                })
            );

            CharacterAttributes memory c = defaultCharacters[i];
            console.log(
                "Done initializing %s w/ HP %s, img %s",
                c.name,
                c.hp,
                c.imageURI
            );
        }
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        CharacterAttributes memory charAttributes = nftHolderAttributes[
            _tokenId
        ];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strAttackDamage = Strings.toString(
            charAttributes.attackDamage
        );
        string memory strShield = Strings.toString(charAttributes.shield);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        charAttributes.name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "CriticalHit is a turn-based NFT game where you take turns to attack the boos.", "image": "',
                        charAttributes.imageURI,
                        '", "attributes": [ { "trait_type": "Health Points", "value": ',
                        strHp,
                        ', "max_value": 300 }, { "trait_type": "Attack Damage", "value": ',
                        strAttackDamage,
                        ', "max_value": 400}, { "trait_type": "Shield", "value": ',
                        strShield,
                        ', "max_value": 100} ]}'
                    )
                )
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    //> Los usuarios podran usar esta función y obtener su NFT en función del characterId que envíen.
    function mintCharacterNFT(uint256 _characterIndex) external {
        //> Obtenemos el tokenId actual (Inicia en 1 ya que se incrementa en el contructor).
        uint256 newItemId = _tokenIds.current();
        //> Asignamos el tokenId a la direccion de la wallet del usuario que llamo a la funcion.
        _safeMint(msg.sender, newItemId);
        // Mapeamos el tokenId => los atributos del personaje.
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].hp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage,
            shield: defaultAttributes[_characterIndex].shield
        });
        //> Mantenemos una manera fácil de ver quién posee qué NFT.
        nftHolders[msg.sender] = newItemId;
        console.log(
            "Minted NFT w/ tokenId %s and characterId %s",
            newItemId,
            _characterIndex
        );
        //> Volvemos a incrementar el _tokenId para el proximo usuario.
        _tokenIds.increment();
        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    function attackBoss() public {
        //> Obtenemos el estado del NFT del jugador.
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        //> Uso la palabra clave 'storage' que al hacer player.hp = 0, cambiaría el valor de salud en el NFT a 0.
        // Si en su lugar usaramos 'memory' haria una copia local de la variable dentro del alcance de la función.
        // Por lo que al hacer player.hp = 0, solo sería así dentro de la función y no cambiaría el valor global.
        CharacterAttributes storage player = nftHolderAttributes[
            nftTokenIdOfPlayer
        ];
        console.log("\nPlayer w/ character %s about to attack", player.name);
        console.log(
            "Player has %s HP, %s AD and %s Sh\n",
            player.hp,
            player.attackDamage,
            player.shield
        );
        console.log(
            "Boss %s has %s HP and %s AD",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.attackDamage
        );
        //> Validamos que el jugador no tenga un NFT con 0 HP.
        require(player.hp > 0, "Error: character must have HP to attack boss.");
        //> Validamos que el Jefe tenga mas de 0 HP.
        require(bigBoss.hp > 0, "Error: boss must have HP to attack boss.");

        //> Permitimos al jugador atacar al jefe.
        if (bigBoss.hp < player.attackDamage) {
            //> Ni solidity ni OpenZeppelin tienen soporte decente para manejar numeros negativos.
            // Si llegamos a encontrarnos con ese caso, editamos el valor del HP a 0.
            bigBoss.hp = 0;
        } else {
            bigBoss.hp = bigBoss.hp - player.attackDamage;
        }

        //> Permitimos al jugador atacar al Jefe
        if ((player.hp + player.shield) < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = (player.hp + player.shield) - bigBoss.attackDamage;
        }

        console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attacked player. New player hp: %s\n", player.hp);

        emit AttackComplete(bigBoss.hp, player.hp);
    }

    function checkIfUserHasNFT()
        public
        view
        returns (CharacterAttributes memory)
    {
        //> Obtenemos el tokenId del personaje NFT del jugador
        uint256 userNftTokenId = nftHolders[msg.sender];
        //> Si el usuario tiene un tokenId en el map, regreso el personaje.
        if (userNftTokenId > 0) {
            return nftHolderAttributes[userNftTokenId];
        }
        //> Caso contrario, regreso un personaje vacio.
        else {
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters()
        public
        view
        returns (CharacterAttributes[] memory)
    {
        return defaultCharacters;
    }

    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }
}
