const Game = artifacts.require("Game");


const DefaultElves = [
    {
        name: 'Aumrauth',
        uri: 'https://i.ibb.co/Jqfxhj7/Character1-face1.png',
        hp: 100,
        damage: 1,
        cost: 100
    },
    {
        uri: 'https://i.ibb.co/fQkH2cv/Character2-face1.png',
        name: 'Zylleth',
        hp: 100,
        damage: 1,
        cost: 200
    },
    {
        uri: 'https://i.ibb.co/2WFBhf1/Character3-face1.png',
        name: 'Haemir',
        hp: 100,
        damage: 1,
        cost: 300
    },
    {
        uri: 'https://i.ibb.co/gD8LSbn/Character4-face1.png',
        name: 'Illianaro',
        hp: 100,
        damage: 1,
        cost: 400
    },
    {
        uri: 'https://i.ibb.co/F8sPbP6/Character5-face1.png',
        name: 'Zumdan',
        hp: 100,
        damage: 1,
        cost: 500
    },
    {
        uri: 'https://i.ibb.co/tChsKMF/Character6-face1.png',
        name: 'Gorluin',
        hp: 100,
        damage: 1,
        cost: 600
    },
    {
        uri: 'https://i.ibb.co/PD0Z8NY/Character7-face1.png',
        name: 'Inaqen',
        hp: 100,
        damage: 1,
        cost: 700
    },
    {
        uri: 'https://i.ibb.co/2NjY9Fn/Character8-face1.png',
        name: 'Folas',
        hp: 100,
        damage: 1,
        cost: 800
    },
]

const transformCharactersToArgs = (characters) => {
    return characters.reduce(( acc, { uri, name, hp, damage, cost}) => {
        acc.uri.push(`${uri}`)
        acc.name.push(name)
        acc.hp.push(hp)
        acc.damage.push(damage)
        acc.cost.push(cost)

        return acc;
    }, { uri: [], name: [], hp: [], damage: [], cost: [] })
}

const {uri, name, hp, damage, cost} = transformCharactersToArgs(DefaultElves)

module.exports = function (deployer) {
    deployer.deploy(
        Game,
        name,
        uri,
        hp,
        damage,
        cost,
        "Svartáljǫfurr",
        "https://static.wikia.nocookie.net/godofwar/images/a/a1/Svart%C3%A1lj%C7%ABfurr_Concept_Art_3.jpg/revision/latest/scale-to-width-down/823?cb=20180629212014",
        10000,
        50,
    );
};
