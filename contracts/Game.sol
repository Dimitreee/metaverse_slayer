// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./StructDeclaration.sol";

import "./lib/Base64.sol";
import "./Game.sol";
import "./Game.sol";

contract Game is ERC721Enumerable {
  mapping(address => MarketPosition) public marketPositions;
  address[] public marketPositionsList;
  BigBoss public bigBoss;

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  Counters.Counter private _marketPositionId;
  Counters.Counter private _totalMarketPositions;

  CharacterAttributes[] defaultCharacters;

  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
  mapping(address => uint256) public nftHolders;
  mapping(address => uint256) public charactersQuantityByUser;
  mapping(address => uint256) public userScore;
  mapping(uint256 => MarketPosition) public market;

  event CharacterNFTMinted(
    address sender,
    uint256 tokenId,
    uint256 characterIndex
  );
  event AttackComplete(uint256 newBossHp, uint256 newPlayerHp);
  event UserScoreUpdated(address sender, uint256 score);
  event MarketPositionCreated();

  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint256[] memory characterHp,
    uint256[] memory characterAttackDmg,
    uint256[] memory charactersCost,
    string memory bossName,
    string memory bossImageURI,
    uint256 bossHp,
    uint256 bossAttackDamage
  ) ERC721("Heroes", "HERO") {
    for (uint256 i = 0; i < characterNames.length; i += 1) {
      defaultCharacters.push(
        CharacterAttributes({
          characterIndex: i,
          name: characterNames[i],
          imageURI: characterImageURIs[i],
          hp: characterHp[i],
          maxHp: characterHp[i],
          attackDamage: characterAttackDmg[i],
          cost: charactersCost[i]
        })
      );
    }

    bigBoss = BigBoss({
      name: bossName,
      imageURI: bossImageURI,
      hp: bossHp,
      maxHp: bossHp,
      attackDamage: bossAttackDamage
    });

    _tokenIds.increment();
  }

  function mintCharacterNFT(uint256 _characterIndex) external {
    uint256 newItemId = _tokenIds.current();

    require(userScore[msg.sender] >= defaultCharacters[_characterIndex].cost);

    _safeMint(msg.sender, newItemId);

    nftHolderAttributes[newItemId] = CharacterAttributes({
      characterIndex: _characterIndex,
      name: defaultCharacters[_characterIndex].name,
      imageURI: defaultCharacters[_characterIndex].imageURI,
      hp: defaultCharacters[_characterIndex].hp,
      maxHp: defaultCharacters[_characterIndex].hp,
      attackDamage: defaultCharacters[_characterIndex].attackDamage,
      cost: 0
    });

    updateUserScore(-int(defaultCharacters[_characterIndex].cost));

    nftHolders[msg.sender] = newItemId;
    charactersQuantityByUser[msg.sender] = charactersQuantityByUser[msg.sender] + 1;

    _tokenIds.increment();
    emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
  }

  function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
    return defaultCharacters;
  }

  function getBigBoss() public view returns (BigBoss memory) {
    return bigBoss;
  }

  function getUserCharacters() public view returns (CharacterAttributes[] memory) {
    uint256 charactersQuantity = charactersQuantityByUser[msg.sender];
    CharacterAttributes[] memory characters = new CharacterAttributes[](charactersQuantity);

    uint i = 0;

    for (i = 0; i < charactersQuantity; i++ ) {
      characters[i] = nftHolderAttributes[tokenOfOwnerByIndex(msg.sender, i)];
    }

    return characters;
  }

  function updateUserScore(int score) public {
    if (score < 0) {
      require(int(userScore[msg.sender]) > score);
    }

    userScore[msg.sender] = uint256(int(userScore[msg.sender]) + score);
    emit UserScoreUpdated(msg.sender, userScore[msg.sender]);
  }

  function getUserScore() public view returns (uint256) {
    return userScore[msg.sender];
  }

//  function createMarketPosition(uint256 tokenId, uint256 price) public {
//    require(tokenOfOwnerByIndex(msg.sender, tokenId));
//
//    Position memory position = Position({
//      tokenId: tokenId,
//      price: price
//    });
//
//    bool succ = newMarketPosition();
//
//    if (succ) {
//      emit MarketPositionCreated();
//    }
//  }
//
//  function isEntity(address entityAddress) public returns(bool) {
//    if(marketPositionsList.length == 0) return false;
//    return (marketPositionsList[marketPositions[entityAddress].listPointer] == entityAddress);
//  }
//
//  function getMarketPositionsCount() public returns(uint) {
//    return marketPositionsList.length;
//  }
//
//  function newMarketPosition(address entityAddress, uint positionData) public returns(bool) {
//    if(isEntity(entityAddress)) revert();
//    marketPositions[entityAddress].positionData = positionData;
//    marketPositions[entityAddress].listPointer = marketPositionsList.push(entityAddress) - 1;
//    return true;
//  }
//
//  function updateMarketPosition(address entityAddress, uint positionData) public returns(bool) {
//    if(!isEntity(entityAddress)) revert();
//    marketPositions[entityAddress].positionData = positionData;
//    return true;
//  }
//
//  function deleteMarketPosition(address entityAddress) public returns(bool) {
//    if(!isEntity(entityAddress)) revert();
//    uint rowToDelete = marketPositions[entityAddress].listPointer;
//    address keyToMove = marketPositionsList[marketPositionsList.length-1];
//    marketPositionsList[rowToDelete] = keyToMove;
//    marketPositions[keyToMove].listPointer = rowToDelete;
//    marketPositionsList.length--;
//    return true;
//  }


  // transferFrom

  // Выставить лот
  // Убрать лот
  // Купить лот
}
