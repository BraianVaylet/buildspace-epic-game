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
    //> Hacemos uso de un struct para manter los atributos de nuestro personaje
    struct CharacterAttributes {
        string name;
        string imageURI;
        uint256 hp;
        uint256 attackDamage;
        uint256 shield;
    }

    //> El tokenId es el identificador unico del NFTs, es un numero que va del 0, 1, 2, 3, etc.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Creamos una variable de estado como un map a partir del tokenId del nft con los atributos del NFT.
    // nftHolderAttributes será donde almacenaremos el estado de los NFT del jugador.
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    mapping(uint256 => CharacterAttributes) public defaultAttributes;
    //> Creamos otra variable de estado como un map desde una dirección con el tokenId del NFT.
    // Esto me da una manera simple de almacenar el propietario del NFT y referenciarlo más tarde.
    mapping(address => uint256) public nftHolders;

    //> Datos pasados ​​al contrato cuando se crea por primera vez inicializandolos
    // vamos a pasar estos valores desde run.js.
    // Tambien agrego un nuevo nombre y símbolo para nuestro token ERC721.
    constructor(
        uint256[] memory characterIds,
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        uint256[] memory characterShield
    ) ERC721("Heroes", "HERO") {
        //> Recorremos todos los caracteres y guardamos sus valores en nuestro contrato para que
        // podemos usarlos más tarde cuando acuñamos nuestros NFT.
        for (uint256 i = 0; i < characterIds.length; i += 1) {
            defaultAttributes[characterIds[i]] = CharacterAttributes({
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                attackDamage: characterAttackDmg[i],
                shield: characterShield[i]
            });

            CharacterAttributes memory c = defaultAttributes[characterIds[i]];
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
    function mintCharacterNFT(uint256 _characterId) external {
        //> Obtenemos el tokenId actual (Inicia en 1 ya que se incrementa en el contructor).
        uint256 newItemId = _tokenIds.current();
        //> Asignamos el tokenId a la direccion de la wallet del usuario que llamo a la funcion.
        _safeMint(msg.sender, newItemId);
        // Mapeamos el tokenId => los atributos del personaje.
        nftHolderAttributes[newItemId] = CharacterAttributes({
            name: defaultAttributes[_characterId].name,
            imageURI: defaultAttributes[_characterId].imageURI,
            hp: defaultAttributes[_characterId].hp,
            attackDamage: defaultAttributes[_characterId].attackDamage,
            shield: defaultAttributes[_characterId].shield
        });
        //> Mantenemos una manera fácil de ver quién posee qué NFT.
        nftHolders[msg.sender] = newItemId;
        console.log(
            "Minted NFT w/ tokenId %s and characterId %s",
            newItemId,
            _characterId
        );
        //> Volvemos a incrementar el _tokenId para el proximo usuario.
        _tokenIds.increment();
    }
}
