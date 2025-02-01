extends Node

const ICON_PATH = "res://Assets/Spritesheets/Enemies/"

var Current_stage = Aeternus.Current_stage ## Current stage name or ID
var Stage_level =  Aeternus.Stage_level ## Difficulty Level 


enum TYPE_LIST { BEAST, ABERRATION, CELESTIAL, CUNSTRUCT, DRAGON, ELEMENTA, FEY, FIEND, GIANT, HUMANOID, MONSTRUOCITY, OOZE, PLANT, UNDEAD, SPECIAL}
enum MONSTER_LIST { NULL, TROLL, WOLF, SKELETON, GOBLIN, ORC, }

var Monster_name_list = [
		null,
		'Troll', 'Wolf', 'Skeleton', 'Goblin', 'Orc'
]


enum HUMANOID {
			HUMAN,
			GOBLINOID,
			GNOME,
			ELF,
			DWARF
		}

#	
#	
#	
#	

var MOSNTER = {
	"Name" : {
		'name' : 'Monster Name',
		'type' : 'beast, aberration, celestial, contruct, dragon, elemental ...',
		'sub_type' : 'goblinoid',
		'stack' : 1,
		'class' : 'warrior, wisard, thief ... ',
		'level' : 'num',
		'rarity' : 'magic, legendary, banal',
		'sprite' :  ICON_PATH + '',
		'weapon' : 'Arabic Sword',
		'dice': 10,
		'dicesQuantity': 1,
		'bonus': 0,
		'attackBonus': 1,
		'damageBonus' : 3,
		'defense': 10,
		'defenseDice': 10,
		'defenseDicesQuantity': 1,
		'defenseBonus': 0,
		'afectedCharacteristics' : ['Strength', 'Dexterity'],
		'bonusToCharacteristic' : [3,2],
	},
	"Skeleton" : {
		'name' : 'Skeleton',
		'type' : 'undead',
		'sub_type' : 'skeleton',
		'size' : 'Medium',
		'race' : 'Human',
		'stack' : 1,
		'class' : 'warrior',
		'level' : 1,
		'rarity' : 'magic',
		'health' : 3,
		'healthDices' : [2,8],
		'healthDice': 8,
		'healthDicesQuantity': 2,
		'sprite' :  ICON_PATH + 'Undeads/skeleton_0.png',
		'weapon' : 'Arabic Sword',
		'dice': 10,
		'dicesQuantity': 1,
		'bonus': 0,
		'attackBonus': 1,
		'damageBonus' : 3,
		'magicAttack' : null,
		'originalSpeed' : 20,
		'chasingSpeed' : 60,
		'chasingMoral' : 100,
		'chasingPerception' : 70,
		'randomPerception' : 3,
		'defense': 10,
		'defenseDice': 10,
		'defenseDicesQuantity': 1,
		'defenseBonus': 0,
		'treasure_type' : 'B',
	},
}


