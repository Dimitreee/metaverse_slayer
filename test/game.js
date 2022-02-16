const Game = artifacts.require("Game");

const DefaultElves = [
    {
        name: 'Aumrauth',
        uri: 'https://ibb.co/MfY8XkV',
        hp: 100,
        damage: 1,
        cost: 100
    },
    {
        uri: 'https://ibb.co/vD3kHtY',
        name: 'Zylleth',
        hp: 100,
        damage: 1,
        cost: 200
    },
    {
        uri: 'https://ibb.co/QpJGQ13',
        name: 'Haemir',
        hp: 100,
        damage: 1,
        cost: 300
    },
    {
        uri: 'https://ibb.co/K9gp2c1',
        name: 'Illianaro',
        hp: 100,
        damage: 1,
        cost: 400
    },
    {
        uri: 'https://ibb.co/YfDr7r2',
        name: 'Zumdan',
        hp: 100,
        damage: 1,
        cost: 500
    },
    {
        uri: 'https://ibb.co/vzBPqxR',
        name: 'Gorluin',
        hp: 100,
        damage: 1,
        cost: 600
    },
    {
        uri: 'https://ibb.co/SfGXpPx',
        name: 'Inaqen',
        hp: 100,
        damage: 1,
        cost: 700
    },
    {
        uri: 'https://ibb.co/Vmvp1Lj',
        name: 'Folas',
        hp: 100,
        damage: 1,
        cost: 800
    },
]

const transformCharactersToArgs = (characters) => {
    return characters.reduce(( acc, { uri, name, hp, damage, cost}) => {
        acc.uri.push(`<${uri}>`)
        acc.name.push(name)
        acc.hp.push(hp)
        acc.damage.push(damage)
        acc.cost.push(cost)

        return acc;
    }, { uri: [], name: [], hp: [], damage: [], cost: [] })
}

const {uri, name, hp, damage, cost} = transformCharactersToArgs(DefaultElves)


contract("Game", function (/* accounts */) {
    let gameContract;

    before(async () => {
        gameContract = await Game.new(
            name,
            uri,
            hp,
            damage,
            cost,
            "Elon Musk",
            "<https://i.imgur.com/AksR0tt.png>",
            10000,
            50
        );
    });

    it("should assert true", async function () {
    });

    it("Should have 3 default characters", async () => {
        let characters = await gameContract.getAllDefaultCharacters();
        expect(characters.length).to.equal(3);
    });

    it("Should have a boss", async () => {
        let boss = await gameContract.getBigBoss();
        expect(boss.name).to.equal("Elon Musk");
    });

    it("Should have 4 minted characters", async () => {
        await gameContract.updateUserScore(666);
        await gameContract.mintCharacterNFT(0);
        await gameContract.mintCharacterNFT(1);
        await gameContract.mintCharacterNFT(2);
        const characters = await gameContract.getUserCharacters()

        expect(characters.map(([_, name]) => name)).to.deep.equal(["Leo", "Aang", "Pikachu"]);
    });

    it("Default characters should have cost", async () => {
        const characters = await gameContract.getAllDefaultCharacters()

        expect(characters.map((character) => character[6])).to.deep.equal(["333", "222", "111"]);
    });

    it("Character cost should be equal to zero while minted", async () => {
        await gameContract.updateUserScore(333);
        await gameContract.mintCharacterNFT(0);
        const characters = await gameContract.getUserCharacters()
        const [firstMintedCharacter] = characters

        expect(firstMintedCharacter[6]).to.deep.equal("0");
    });

    it("Should update user score correctly with positive and negative numbers", async () => {
        await gameContract.updateUserScore(10)
        const score = await gameContract.getUserScore()

        expect(score.toNumber()).to.be.equal(10);
        // Reset score state
        await gameContract.updateUserScore(-10)
    })

    it("Should update user score correctly with negative numbers", async () => {
        await gameContract.updateUserScore(110)
        await gameContract.updateUserScore(-100)
        const score = await gameContract.getUserScore()

        expect(score.toNumber()).to.be.equal(10);
    })

    it("Should decrease user score while minting character", async () => {
        await gameContract.updateUserScore(400)
        await gameContract.mintCharacterNFT(0);
        const score = await gameContract.getUserScore()

        expect(score.toNumber()).to.be.equal(77);
    })
});
