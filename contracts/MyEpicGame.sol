// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract MyEpicGame {
    //> Hacemos uso de un struct para manter los atributos de nuestro personaje
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
        uint256 shield;
    }
    //> Hacemos uso de una matriz para ayudarnos a mantener los datos predeterminados para nuestros personajes.
    // útil cuando inventemos nuevos personajes y necesitemos saber cosas como su HP, AD, etc.
    CharacterAttributes[] defaultCharacters;

    //> Datos pasados ​​al contrato cuando se crea por primera vez inicializandolos
    // vamos a pasar estos valores desde run.js.
    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        uint256[] memory characterShield
    ) {
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
}
