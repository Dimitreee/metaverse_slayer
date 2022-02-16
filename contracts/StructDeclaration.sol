// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

struct CharacterAttributes {
    uint256 characterIndex;
    string name;
    string imageURI;
    uint256 hp;
    uint256 maxHp;
    uint256 attackDamage;
    uint256 cost;
}

struct BigBoss {
    string name;
    string imageURI;
    uint256 hp;
    uint256 maxHp;
    uint256 attackDamage;
}

struct Position {
    uint256 tokenId;
    uint256 price;
}

struct MarketPosition {
    Position positionData;
    uint listPointer;
}
