extends Node

const ICON_PATH = "res://Assets/Images/Items/"
const ANIM_PATH = "res://Assets/Images/Spritesheets/"

## var Current_stage = Aeternus.Current_stage ## Current stage name or ID
## var Stage_level =  Aeternus.Stage_level ## Difficulty Level 

var rng #= RandomNumberGenerator.new()

enum CLASS_LIST { COINS, POTION, AMULET, ARMOR, WEAPON, IMPLEMENT, SCROLL, SPECIAL }

enum ARMORS { NATURAL_ARMOR ,
			LEATHER_ARMOR,
			CHAIN_ARMOR,
			PLATE_ARMOR,
			RONDELLE_SHIELD,
			HEATER_SHIELD,
			HERALDIC_SHIELD,
			HELMET,
			GARADIAN_HELMET,
			GONOR_HELMETS,
			CLOSE_HELM,
			HORNED_HELM, 
}

var Armors_name_list = [
			"Natural Armor",
			"Leather Armor",
			"Chain Armor",
			"Plate Armor",
			#"Inmortal Armor",
			"Rondelle Shield",
			"Heater Shield",
			"Heraldic Shield",
			"Helmet",
			"Garadian Helmet",
			"Gonor Helmet",
			"Close Helm",
			"Horned Helm",
]

var Armors_DB = {
	"Natural Armor" : {
		'name' : "Natural Armor",
		'itemClass' : "armor",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'skyn_armor',
		'level' : 1,
		'selling_price' : 0,
		'buying_price' : 0,
		'rarity' : "banal",
		'icon' : [8,4],
		'icon_inventary' :  null , #ICON_PATH + "Weapons/morning_star_1.png",
		'slot' : null,
		'animation' : null,
		'speed' : 1,
		'dices' : [0,0],
		'dice': 1,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 0,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Leather Armor" : {
		'name' : "Leather Armor",
		'itemClass' : "armor",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'leather_armor',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [7,3],
		'icon_inventary' :  ICON_PATH + "Weapons/leather_armor_1.png",
		'slot' : "CHEST",
		'animation' : ANIM_PATH + 'Armors/leather_armor',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Chain Armor" : {
		'name' : "Chain Armor",
		'itemClass' : "armor",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'chain_armor',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [7,3],
		'icon_inventary' :  ICON_PATH + "Weapons/chain_armor_1.png",
		'slot' : "CHEST",
		'animation' : ANIM_PATH + 'Armors/chain_armor',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 2,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 2,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Plate Armor" : {
		'name' : "Plate Armor",
		'itemClass' : "armor",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'plate_armor',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [7,3],
		'icon_inventary' :  ICON_PATH + "Weapons/plate_armor_1.png",
		'slot' : "CHEST",
		'animation' : ANIM_PATH + 'Armors/plate_armor',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 3,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 3,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Rondelle Shield" : {
		'name' : "Rondelle Shield",
		'itemClass' : "shield",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'rondelle_shield',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [8,3],
		'icon_inventary' :  ICON_PATH + "/leather_armor_1.png",
		'slot' : "SHIELD",
		'animation' : ANIM_PATH + 'Shields/rondelle_shield',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 2,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Heater Shield" : {
		'name' : "Heater Shield",
		'itemClass' : "shield",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'heater_shield',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [8,3],
		'icon_inventary' :  ICON_PATH + "Shield/.png",
		'slot' : "SHIELD",
		'animation' : ANIM_PATH + 'Shields/heater_shield',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 2,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 4,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Heraldic Shield" : {
		'name' : "Heraldic Shield",
		'itemClass' : "shield",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'herladic_shield',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [8,3],
		'icon_inventary' :  ICON_PATH + "Weapons/leather_armor_1.png",
		'slot' : "SHIELD",
		'animation' : ANIM_PATH + 'Shields/heraldic_shield',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 3,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 6,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Helmet" : {
		'name' : "Helmet",
		'itemClass' : "helmet",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'helmet',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [7,4],
		'icon_inventary' :  ICON_PATH + "Weapons/leather_armor_1.png",
		'slot' : "HEAD",
		'animation' : ANIM_PATH + 'Helmets/helmet',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 1,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Garadian Helmet" : {
		'name' : "Garadian Helmet",
		'itemClass' : "helmet",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'garadian_helmet',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [7,4],
		'icon_inventary' :  ICON_PATH + "Weapons/leather_armor_1.png",
		'slot' : "HEAD",
		'animation' : ANIM_PATH + 'Helmets/garadian_helmet',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Gonor Helmet" : {
		'name' : "Gonor Helmet",
		'itemClass' : "helmet",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'gonor_helmet',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [7,4],
		'icon_inventary' :  ICON_PATH + "Weapons/leather_armor_1.png",
		'slot' : "HEAD",
		'animation' : ANIM_PATH + 'Helmets/gonor_helmet',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Close Helm" : {
		'name' : "Close Helm",
		'itemClass' : "helmet",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'close_helmet',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [7,4],
		'icon_inventary' :  ICON_PATH + "Weapons/leather_armor_1.png",
		'slot' : "HEAD",
		'animation' : ANIM_PATH + 'Helmets/close_helmet',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 2,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Horned Helm" : {
		'name' : "Horned Helm",
		'itemClass' : "helmet",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'horned_helmet',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [7,4],
		'icon_inventary' :  ICON_PATH + "Weapons/leather_armor_1.png",
		'slot' : "HEAD",
		'animation' : ANIM_PATH + 'Helmets/horned_helmet',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 2,
		'dicesQuantity': 2,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
}

enum WEAPONS { NULL,
			BATTLE_AXE,
			WAR_AXE,
			CLUB,
			LONG_SWORD,
			ARABIC_SWORD,
			MORNINGSTAR,
			WAR_HAMMER,
}
#HAND_AXE, HAMMER, MAUL,C UDGEL, TRIPLE_MORNINGSTAR,
#SWORD, #SABRE, #SCIMITAR, #ARABA_SCIMITAR, #DAGGER, #PERSIAN_SWORD,

var Weapons_name_list = [
	 		null,
			"Battle Axe",
			"War Axe",
			"Club",
			"Long Sword",
			"Arabic Sword",
			"Morning Star",
			"War Hammer",
]

#"Sabre", #"Scimitar", #"Araba Scimitar",
#"Arabic Sword", #"Dagger", #"Persian Sword", #"Club",
var Weapons_DB = {
	"Punch" : {
		'name' : "Punch",
		'itemClass' : "weapon",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'long_sword',
		'group_list' : 'Weapons',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [8,4],
		'icon_inventary' : null, #ICON_PATH + "Weapons/long_sword_01.png",
		'slot' : "NONE",
		'animation' : null,
		'speed' : 8,
		'dice': 4,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : 'hit',
		'attack_scope' : 35, 
		'bonus_afect_to' : null,
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Battle Axe" : {
		'name' : "Battle Axe",
		'itemClass' : "weapon",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'battle_axe',
		'group_list' : 'Weapons',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [5,4],
		'icon_inventary' : ICON_PATH + "Weapons/battle_axe_1.png",
		'slot' : "WEAPON",
		'animation' : ANIM_PATH + 'Weapons/battle_axe',
		'speed': 4,
		'dice': 6,
		'dicesQuantity': 2,
		'bonus': null, 
		'damage_type' : 'hit',
		'attack_scope' : 47, 
		'bonus_afect_to' : null,
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 2,
		'damageBonus' : 2,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},	
	"War Axe" : {
		'name' : "War Axe",
		'itemClass' : "weapon",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'war_axe',
		'group_list' : 'Weapons',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [5,4],
		'icon_inventary' : ICON_PATH + "Weapons/war_axe_1.png",
		'slot' : "WEAPON",
		'animation' : ANIM_PATH + 'Weapons/war_axe',
		'speed': 4,
		'dice': 6,
		'dicesQuantity': 2,
		'bonus': null, 
		'damage_type' : 'hit',
		'attack_scope' : 47, 
		'bonus_afect_to' : null,
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 2,
		'damageBonus' : 2,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},	
	"Club" : {
		'name' : "Club",
		'itemClass' : "weapon",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'club',
		'group_list' : 'Weapons',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [6,4],
		'icon_inventary' : ICON_PATH + "Weapons/club_1.png",
		'slot' : "WEAPON",
		'animation' : ANIM_PATH + 'Weapons/club',
		'speed' : 5,
		'dice': 6,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : 'hit',
		'attack_scope' : 43, 
		'bonus_afect_to' : null,
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Long Sword" : {
		'name' : "Long Sword",
		'itemClass' : "weapon",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'long_sword',
		'group_list' : 'Weapons',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [5,3],
		'icon_inventary' : ICON_PATH + "Weapons/long_sword_1.png",
		'slot' : "WEAPON",
		'animation' : ANIM_PATH + 'Weapons/long_sword',
		'speed' : 6,
		'dice': 6,
		'dicesQuantity': 1,
		'bonus': 0,
		'damage_type' : 'cut',
		'attack_scope' : 15, 
		'bonus_afect_to' : null,
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Arabic Sword" : {
		'name' : "Arabic Sword",
		'itemClass' : "weapon",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'arabic_sword',
		'group_list' : 'Weapons',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [5,3],
		'icon_inventary' : ICON_PATH + "Weapons/arabic_sword_1.png",
		'slot' : "WEAPON",
		'animation' : ANIM_PATH + 'Weapons/long_sword',
		'speed' : 6,
		'dice': 6,
		'dicesQuantity': 1,
		'bonus': 0,
		'damage_type' : 'cut',
		'attack_scope' : 15, 
		'bonus_afect_to' : null,
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Morning Star" : {
		'name' : "Morning Star",
		'itemClass' : "weapon",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'morning_star',
		'group_list' : 'Weapons',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [4,3],
		'icon_inventary' : ICON_PATH + "Weapons/morning_star_1.png",
		'slot' : "WEAPON",
		'animation' : ANIM_PATH + 'Weapons/morning_star',
		'speed' : 6,
		'dice': 6,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : 'hit',
		'attack_scope' : 43, 
		'bonus_afect_to' : null,
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 1,
		'damageBonus' : 1,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"War Hammer" : {
		'name' : "War Hammer",
		'itemClass' : "weapon",
		'importantItem' : false,
		'stackable' : false,
		'stack' : 1,
		'type' : 'war_hammer',
		'group_list' : 'Weapons',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [6,3],
		'icon_inventary' : ICON_PATH + "Weapons/war_hammer_1.png",
		'slot' : "WEAPON",
		'animation' : ANIM_PATH + 'Weapons/war_hammer',
		'speed' : 6,
		'dice': 6,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : 'hit',
		'attack_scope' : 43, 
		'bonus_afect_to' : null,
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 1,
		'damageBonus' : 1,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
}

enum POTIONS { NULL,
			HEALTH_POTION,
			ENERGY_POTION,
			RECOVERY_POTION,
			MANA_POTION,
			STRENGTH_POTION,
			ARMOR_POTION,
			INVULNERABILITY_POTION,
}

enum POTION_SIZE {SMALL, MEDIUM, LARGE, EXTRA_LARGE}

var Potions_name_list = [
			null,
			"Health Potion",
			"Energy Potion",
			"Recovery Potion",
			"Mana Potion",
			"Strength Potion",
			"Armor Potion",
			"Invulnerability Potion",
]

var Potions_DB = {
	"Health Potion" : {
		'name' : "Health Potion",
		'itemClass' : "potion",
		'importantItem' : false,
		'group_list' : 'Potions',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'health potion',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [3,0], 
		'icon_inventary' : ICON_PATH + 'Potions/red_potion_',
		'slot' : "IN_BELT",
		'animation' : null,
		'dices' : [1,10],
		'dice': 10,
		'dicesQuantity': 1,
		'bonus': null,
		'bonus_afect_to' : ["Health"],
		'cooldown' : null,
		'attackBonus': null,
		'damageBonus' : null,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Energy Potion" : {
		'name' : "Energy Potion",
		'itemClass' : "potion",
		'importantItem' : false,
		'group_list' : 'Potions',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'energy potion',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [3,1], 
		'icon_inventary' : ICON_PATH + 'Potions/cyan_potion_',
		'slot' : "IN_BELT",
		'animation' : null,
		'dices' : [2,20],
		'dice': 20,
		'dicesQuantity': 2,
		'bonus': null,
		'bonus_afect_to' : ["Energy"],
		'cooldown' : null,
		'attackBonus': null,
		'damageBonus' : null,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Recovery Potion" : {
		'name' : "Recovery Potion",
		'itemClass' : "potion",
		'importantItem' : false,
		'group_list' : 'Potions',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'recovery potion',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [0,0], 
		'icon_inventary' : ICON_PATH + 'Potions/pink_potion_', # pink_potion_',
		'slot' : "IN_BELT",
		'animation' : null,
		'dices' : [25, null],
		'dice': null,
		'dicesQuantity': 25, # if dice == null : add dicesQuantity %  -> bonus_afect_to  max_bonus_afect_to / 100 * dicesQuantity
		'bonus': null,
		'bonus_afect_to' : ["Energy", "Health"],
		'cooldown' : null,
		'attackBonus': null,
		'damageBonus' : null,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Mana Potion" : {
		'name' : "Mana Potion",
		'itemClass' : "potion",
		'importantItem' : false,
		'group_list' : 'Potions',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'Mana potion',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "magic",
		'icon' : [6,0], 
		'icon_inventary' : ICON_PATH + 'Potions/blue_potion_',
		'slot' : "IN_BELT",
		'animation' : null,
		'dices' : [1,10],
		'dice': 10,
		'dicesQuantity': 1,
		'bonus': null, 
		'bonus_afect_to' : ["Mana"],
		'state_afected' : "invisible",
		'cooldown' : 700 ,
		'attackBonus': null,
		'damageBonus' : null,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Strength Potion" : {
		'name' : "Strength Potion",
		'itemClass' : "potion",
		'importantItem' : false,
		'group_list' : 'Potions',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'strength potion',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [6,1], 
		'icon_inventary' : ICON_PATH + 'Potions/yellow_potion_',
		'slot' : "IN_BELT",
		'animation' : null,
		'dices' : [2,3],
		'dice': 3,
		'dicesQuantity': 2,
		'bonus': null,
		'bonus_afect_to' : ["Strength"],
		'cooldown' : 15,
		'attackBonus': null,
		'damageBonus' : null,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Armor Potion" : {
		'name' : "Armor Potion",
		'itemClass' : "potion",
		'importantItem' : false,
		'group_list' : 'Potions',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'armor potion',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [0,1], 
		'icon_inventary' : ICON_PATH + 'Potions/green_potion_',
		'slot' : "IN_BELT",
		'animation' : null,
		'dices' : [0,0],
		'dice': null,
		'dicesQuantity': null,
		'bonus': 4,
		'bonus_afect_to' : ["Armor"],
		'cooldown' : 10,
		'attackBonus': null,
		'damageBonus' : null,
		'defense': null,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Invulnerability Potion" : {
		'name' : "Invulnerability Potion",
		'itemClass' : "potion",
		'importantItem' : false,
		'group_list' : 'Potions',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'invulnerability potion',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [6,2], 
		'icon_inventary' : ICON_PATH + 'Potions/white_potion_',
		'slot' : "IN_BELT",
		'animation' : null,
		'dices' : [0,0],
		'dice': null,
		'dicesQuantity': null,
		'bonus': 100 ,
		'bonus_afect_to' : ["Armor"],
		'cooldown' : 10 ,
		'attackBonus': null,
		'damageBonus' : null,
		'defense': 1000,
		'defenseDice': null,
		'defenseDicesQuantity': null,
		'defenseBonus': null,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
}

enum IMPLEMENTS {
	BOOTS,
	BELT,
	GLOVES,
}

var Implements_name_list = [
	"Boots",
	"Belt",
	"Gloves",
]


var Implements_DB = {
	"Boots" : {
		'name' : "Boots",
		'itemClass' : "implement",
		'importantItem' : false,
		'class' : 'implement',
		'stackable' : false,
		'stack' : 1,
		'type' : 'boots',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [9,3],
		'icon_inventary' :  ICON_PATH + "Weapons/chain_armor_1.png",
		'slot' : "FEET",
		'animation' : ANIM_PATH +  'Implements/boots',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 4,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Belt" : {
		'name' : "Belt",
		'itemClass' : "implement",
		'importantItem' : false,
		'class' : 'implement',
		'stackable' : false,
		'stack' : 1,
		'type' : 'belt',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [9,4],
		'icon_inventary' :  ICON_PATH + "Weapons/chain_armor_1.png",
		'slot' : "BELT",
		'animation' : ANIM_PATH +  'Implements/belt',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 4,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
	"Gloves":{
		'name' : "Gloves",
		'itemClass' : "implement",
		'importantItem' : false,
		'class' : 'implement',
		'stackable' : false,
		'stack' : 1,
		'type' : 'gloves',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [8,4],
		'icon_inventary' :  ICON_PATH + "Weapons/chain_armor_1.png",
		'slot' : "GLOVES",
		'animation' : ANIM_PATH +  'Implements/gloves',
		'speed' : 1,
		'dices' : [0,0],
		'dice': 4,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 1,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	}
}

enum AMULETS {
			#NULL,
			FETISH,
			RING,
			NECKACE,
}

var Amulets_name_list = [ 
			#null,
			"Fetish",
			"Ring",
			"Necklace",
]

var Amulets_DB = { ## Create a random generator of amiulte, with powes and name
	"Fetish" : {
		'name' : 'Fetish',
		'type' : 'Fetish',
		'group_list' : 'Amultes',
		'itemClass' : 'amulet',
		'importantItem' : false,
		'class' : 'amulet',
		'selling_price' : 10,
		'buying_price' : 20,
		'icon' : [0,2],
		'bonus_afect_to' : ["Armor"],
		'bonus' : 5,
		'dices' : [1,10],
		'rarity' : 'random',
		'slot' : 'FETISH',
		'animation' : null,
	},
	"Ring" : {
		'name' : 'Amulte..',
		'type' : 'Ring',
		'group_list' : 'Amultes',
		'itemClass' : 'amulet',
		'importantItem' : false,
		'class' : 'amulet',
		'selling_price' : 10,
		'buying_price' : 20,
		'bonus_afect_to' : ["Armor"],
		'icon' : [0,2],
		'bonus' : 5,
		'dices' : [1,10],
		'rarity' : 'random',
		'slot' : 'RING',
		'animation' : null,
	},
	"Necklace" : {
		'name' : 'Amulte..',
		'type' : 'Necklace',
		'group_list' : 'Amultes',
		'itemClass' : 'amulet',
		'importantItem' : false,
		'class' : 'amulet',
		'selling_price' : 10,
		'buying_price' : 20,
		'icon' : [0,2],
		'bonus_afect_to' : ["Armor"],
		'bonus' : 5,
		'dices' : [1,10],
		'rarity' : 'random',
		'slot' : 'NECKLACE',
		'animation' : null,
	},
}

## Gems

enum GEMS { NULL,

}
var Gems_name_list = [
			null,
]
var Gems_DB = {}

### Runes

enum RUNES { NULL,

}
var Runes_name_list = [
			null,
]
var Runes_DB = {}

### Keys

enum KEYS { NORMAL_KEY, MASTER_KEY, SINGLE_KEY }
var Keys_name_list = [ 'Normal Key', 'Master Key', 'Single Key', ]
var Keys_DB = {
	'Normal Key' : { # a key that opens all small doors   #
		'name' : 'Normal Key',
		'open_code' : 00,
		'magic' : false,
		'itemClass' : "key",
		'importantItem' : false,
		'group_list' : 'Keys',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'normal key',
		'level' : 1,
		'selling_price' : 1,
		'buying_price' : 2,
		'rarity' : "banal",
		'icon' : [0,3], 
		'icon_inventary' : ICON_PATH + 'Keys/key_normal.png',
		'slot' : null,
		'animation' : null,
	},
	'Master Key' : { # a key that opens all doors (except special)  #
		'name' : 'Master Key',
		'open_code' : 369,
		'magic' : false,
		'itemClass' : "key",
		'importantItem' : false,
		'group_list' : 'Keys',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'master key',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "rare",
		'icon' : [0,3], 
		'icon_inventary' : ICON_PATH + 'Keys/key_master.png',
		'slot' : null,
		'animation' : null,
	},
	'Single Key' : { # a single key for a single door #
		'name' : 'Single Key',
		'open_code' : 3030303030,
		'magic' : false,
		'itemClass' : "key",
		'importantItem' : false,
		'group_list' : 'Keys',
		'stackable' : true,
		'stack' : 1,
		'stock' : 1,
		'is_in_belt' : null,
		'type' : 'single key',
		'level' : 1,
		'selling_price' : 10,
		'buying_price' : 20,
		'rarity' : "banal",
		'icon' : [0,3], 
		'icon_inventary' : ICON_PATH + 'Keys/key_single.png',
		'slot' : null,
		'animation' : null,
	}
}


enum SPECIAL { NULL,
			MAGIC_WEAPONS,
			MAGIC_EVERITHING
}

var special_name_list = [
			null,
			"MAGIC_WEAPONS",
			"MAGIC_EVERITHING"
]

var Special_DB

## Monster level 
## Monstter nature

var GLOBAL_TREASURE_LIST = ['Coins', 'Gems', 'Potions', 'Armors', 'Weapons', 'Keys', 'Amulets', 'Scrolls']

var TREASURE = {
	##	  Coins        Gems        Potio       Armor       Weapon      Keys        Amulet       Scroll
	'A' : [[20,[1,4]], [15,[1,1]], [10,[1,1]], [05,[1,1]], [15,[1,1]], [15,[1,1]], [05,[1,2]], [05,[1,1]],], # Animal mazmorra
	'B' : [[40,[1,4]], [20,[1,1]], [20,[1,2]], [30,[1,1]], [30,[1,1]], [20,[1,2]], [10,[1,1]], [10,[1,1]],], # Entidad mazmorra
	'C' : [[45,[1,6]], [25,[1,2]], [20,[1,2]], [25,[1,2]], [40,[1,1]], [45,[1,3]], [20,[1,2]], [15,[1,1]],], # Persona Normal, Orco, ladron
	'D' : [[66,[1,6]], [45,[1,4]], [50,[1,2]], [80,[1,4]], [70,[1,2]], [95,[1,1]], [35,[1,2]], [30,[1,1]],], # Guardia , Madriguera animal, Ogro
	'E' : [[80,[2,4]], [60,[1,4]], [80,[1,3]], [40,[1,3]], [80,[1,2]], [50,[1,3]], [95,[1,3]], [50,[1,3]],], # Cortesano, Guarida de Ogro, Cofre Mazmorra
	'F' : [[90,[2,6]], [80,[1,3]], [80,[1,2]], [50,[1,3]], [80,[1,2]], [50,[1,3]], [70,[1,2]], [60,[1,3]],], # Elfo, Comerciante, personalidad
	'G' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], # 
	'H' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], # 
	'I' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], #
	'J' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], #
	'K' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], #
	'L' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], #
	'M' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], #
	'N' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], #
	'O' : [[95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]], [95,[1,6]],], #
	'P' : [[95,[3,6]], [95,[3,6]], [95,[3,6]], [95,[3,6]], [95,[3,6]], [95,[3,6]], [95,[3,6]], [95,[3,6]],], #
}


var GLOBAL_TREASURE_DICT = {
	'Coins': {
		'name' : 'Coins',
		'method' : '',
	},
	'Gems': {
		'name' : 'Gems',
	},
	'Potions': {
		'name' : 'Potions',
		'options' : ["Health Potion", "Energy Potion", "Recovery Potion", "Mana Potion",
					"Strength Potion", "Armor Potion", "Invulnerability Potion",],
		'object' : Potions_DB ,
		'name_list' : Potions_name_list,
	},
	'Armors': {
		'name' : 'Armors',
		'options' : ["Leather Armor", "Chain Armor", "Plate Armor",
					"Rondelle Shield", "Heater Shield", "Heraldic Shield",
					"Helmet", "Garadian Helmet", "Gonor Helemt", "Close Helm", "Horned Hlem"],
		'object' : Armors_DB ,
		'name_list' : Armors_name_list,
	},
	'Weapons': {
		'name' : 'Weapons',
		'options' : ["Battle Axe", "War Axe", "Club", "Long Sword", "Arabic Sword", "Morningstar",],
		'object' : Weapons_DB ,
		'name_list' : Weapons_name_list,
	},
	'Keys': {
		'name' : 'Keys',
		'options' : ['Normal Key', 'Master Key', 'Single_Key'],
		'object' : Keys_DB,
		'name_list' : Keys_name_list,
	},
	'Amulets' : {
		'name' : 'Amulets',
		'options' : [ "Fetish", "Ring", "Necklace",],
		'object' : Amulets_DB ,
		'name_list' : Amulets_name_list,
	},
	'Implements' : {
		'name' : 'Implements',
		'options' : ["Boots", "Belt", "Gloves"],
		'object' : Implements_DB ,
		'name_list' : Implements_name_list , 
	},
	'Scrolls': {
		'name' : 'Scrolls',
	},
	'Special': {
		'name' : 'Special',
	},
	'random': {
		'name' : 'random',
	}
}

# Rarity
#var Item_Rarity_List = ['common', 'uncommon', 'rare', 'epic', 'magic', 'legendary', 'mythic', 'relic', 'masterwork', 'eternal']
var Rarity_list = ['common', 'uncommon', 'rare', 'epic', 'legendary', 'mythic',]
var Rarity_elements = {
		'common' : {
			'map_icon': 1, ## not used
			'icon_path' : "", ## not used
			'icon_path_range' : [1,1],
			'min_characteristic_bonus' : 1,
			'min_bonus_to_characteristic' : 0,
		}, 
		'uncommon' : {
			'map_icon': 1, ## not used
			'icon_path' : "", ## not used
			'icon_path_range' : [1,2],
			'min_characteristic_bonus' : 2,
			'min_bonus_to_characteristic' : 0,
		}, 
		'rare' : {
			'map_icon': 1, ## not used
			'icon_path' : "", ## not used
			'icon_path_range' : [2,5],
			'min_characteristic_bonus' : 3,
			'min_bonus_to_characteristic' : 0,
		}, 
		'epic' : {
			'map_icon': 1, ## not used
			'icon_path' : "", ## not used
			'icon_path_range' : [5,7],
			'min_characteristic_bonus' : 4,
			'min_bonus_to_characteristic' : 1,
		}, 
		'legendary' : {
			'map_icon': 1, ## not used
			'icon_path' : "", ## not used
			'icon_path_range' : [6,8],
			'min_characteristic_bonus' : 5,
			'min_bonus_to_characteristic' : 2,
		}, 
		'mythic' : {
			'map_icon': 1, ## not used
			'icon_path' : "", ## not used
			'icon_path_range' : [8,8],
			'min_characteristic_bonus' : 6,
			'min_bonus_to_characteristic' : 3,
		},
}


var CHAR_AFFECTATION = [ 'Strength', 'Constitution', 'Dexterity', 'Chance', 'Attack', 
						'Armor', 'Energy', 'Damage', 'Health', 'Mana', 'Speed']
						#'Intelligence', 'Wisdom', 'Charisma', ]

func _ready():
	randomize()

func generate_item(item):
	item.unique_id = Aeternus.generate_unique_ID(item.name)

func generate_unique_ID(Item_name):
	var new_name = Item_name + '_' + str( rng.randfn() ) 
	new_name = new_name.replace('.','_')
	return new_name.to_snake_case()

func rarity_choosig(range_range):
	#['common', 'uncommon', 'rare', 'epic', 'legendary', 'mythic',]
	var chance = Aeternus.HERO.Chance
	var hero_level = Aeternus.HERO.Level
	if range_range <= chance - 4 :
		#return Rarity_list[3]
		return 'mythic'
	elif range_range <= chance :
		#return Rarity_list[2]
		return 'legendary'
	elif range_range <= chance + hero_level :
		#return Rarity_list[1]
		return 'epic'
	elif range_range <= chance + hero_level + 5 :
		#return Rarity_list[0]
		return 'rare'
	elif range_range <= chance + hero_level + 10 :
		return 'uncommon'	
	else :
		return 'common'	
		
func generate_loot(treasureType) :
	##		0		1	   2		3		4		5		6		7		
	##	  	Coins   Gems   Potions  Armors  Weapons Keys  	Amulets Scrolls 
	#print('Generate loot')
	var treasure = {}
	var index = 0
	for tr in TREASURE[treasureType] :
		if Aeternus.percent_trough(tr[0] + Aeternus.HERO.Chance) :
			var quantity = Aeternus.dice_through(tr[1][0], tr[1][1])
			treasure[GLOBAL_TREASURE_DICT[GLOBAL_TREASURE_LIST[index]].name] = quantity
		index += 1
	return treasure	

func affectation_to_char(Stage, rarity) :
	return int(rng.randi_range((Stage / 2), Aeternus.HERO.Level)) + Rarity_elements[rarity].min_bonus_to_characteristic

func determine_dices(item, rarity):
	return 

func random_pick_from_list(name):
	return GLOBAL_TREASURE_DICT[name].options[rng.randi( ) % GLOBAL_TREASURE_DICT[name].options.size()]

func potion_maker(potion) :
	#print('potion maker')
	var Stage_level = Aeternus.Stage_level
	var POTION = potion
	POTION.level = int(Stage_level / 3) if int(Stage_level / 3) > 1 else 1
	var icon_level = '1' if potion.level < 2 else '2' if potion.level < 4 else '3'
	POTION.icon_inventary = potion.icon_inventary + icon_level + '.png'
	POTION.icon[0] = potion.icon[0] if POTION.level < 2 else potion.icon[0] + 1 if POTION.level < 4 else potion.icon[0] + 2
	POTION.dices[0] = potion.dices[0] if POTION.level < 2 else potion.dices[0] + 1 if POTION.level < 4 else potion.dices[0] + 2
	POTION.unique_id = generate_unique_ID(potion.name) 
	#generate_loot('xd')
	return POTION

func random_Item_Generator(Item_cat, Item_name = null):
	#print('here -> ', Item_cat )
	rng = RandomNumberGenerator.new()
	var Stage_level = Aeternus.Stage_level
	var List = Item_cat + '_name_list'
	# Pick a random element from GLOBAL_TREASURE_DICT 
	var Item_type = random_pick_from_list(Item_cat) if Item_name == null else Item_name 
	# from GLOBAL_TREASURE_DICT now it pick an original and make a copy
	var Rand_Item = GLOBAL_TREASURE_DICT[Item_cat].object[Item_type].duplicate(true)
	# rarity random 
	var rarity = rarity_choosig(rng.randi( ) % 100)
	# still empty. Array of characeristics
	var affected_char =  []
		#var num_of_characteristis = floori(Stage_level / 2) if Stage_level > 1 else 1
	var num_of_characteristis = Rarity_elements[rarity].min_characteristic_bonus    # floori(Stage_level / 2) if Stage_level > 1 else 1
	var item_level = int(Stage_level / 2) if int(Stage_level / 2) > 1 else 1
	# number of the icon icon 
	var icon_number = str(rng.randi_range( Rarity_elements[rarity].icon_path_range[0] , Rarity_elements[rarity].icon_path_range[1] ))
	
	var icon_path = Item_cat + '/'+ Item_type.to_lower().to_snake_case() + '_' +  icon_number  + '.png'
	#var icon_level = str(rng.randi_range( 1 , 3 )) #if Item_cat != 'Potions' else '1'
	Rand_Item.name = Aeternus.random_Name_Generator(Item_type, rarity) if rarity != 'common' else Item_type 
	Rand_Item.type = Item_cat
	Rand_Item.class = Rand_Item.itemClass
	Rand_Item.itemClass = Item_cat.to_lower().to_snake_case()
	Rand_Item.bonus_afect_to = []
	Rand_Item.affectations = {}
	Rand_Item.level = rng.randi_range(Stage_level, (Aeternus.HERO.Level + Stage_level)) 
	Rand_Item.rarity = rarity 
	Rand_Item.slot =  Aeternus.get_slot_from_list(Item_cat + '_DB', Item_type.capitalize()) #Item_type.to_upper()
	Rand_Item.dices = [0,0]
	Rand_Item.icon_inventary = ICON_PATH + icon_path #Item_cat + '/'+ Item_type.to_lower().to_snake_case() + '_' + icon_level + '.png'
	Rand_Item.stackable = false if Item_cat != 'Scrolls' or Item_cat != 'Potions' else true
	Rand_Item.icon = Aeternus.get_icon_from_list(Item_cat + '_DB', Item_type.capitalize())
	Rand_Item.selling_price = Rand_Item.selling_price * Rand_Item.level
	Rand_Item.buying_price = Rand_Item.buying_price * Rand_Item.level
	print('Rand_Item.selling_price -> ',Rand_Item.selling_price)
	print('Rand_Item.buying_price -> ',Rand_Item.buying_price)


	if Rand_Item.class == 'shield' :
		Rand_Item.animation_front = Rand_Item.animation + '_front' + icon_number + '.png' if Rand_Item.animation != null else ''
		Rand_Item.animation_back = Rand_Item.animation + '_back' + icon_number + '.png' if Rand_Item.animation != null else ''
		
	Rand_Item.animation = Rand_Item.animation + '_' + icon_number + '.png' if Rand_Item.animation != null else ''

		#'attack_scope' : 15, 
		#'state_afected' : null,
		#'cooldown' : null ,
		#'attackBonus': 0,
		#'damageBonus' : 0,
		#'defense': null,
		#'defenseDice': null,
		#'defenseDicesQuantity': null,
		#'defenseBonus': null,
		#'afectedCharacteristics' : null,
		#'bonusToCharacteristic' : null,
	
	Rand_Item.bonus_afect_to = affected_char
	
	if Item_cat == 'Weapons' :
		var Weapon_chars = ['Attack', 'Damage', 'Speed']
		num_of_characteristis -= 1
		affected_char.push_back(Weapon_chars[rng.randi() % Weapon_chars.size()])
		Rand_Item.affectations['Attack'] =  affectation_to_char(Stage_level, Rand_Item.rarity)
		Rand_Item.bonus_afect_to.push_back('Attack')
		Rand_Item.dices = [Rand_Item.dicesQuantity + Rarity_elements[Rand_Item.rarity].min_bonus_to_characteristic , Rand_Item.dice + (Rarity_elements[Rand_Item.rarity].min_characteristic_bonus - 1) ]
		Rand_Item.dicesQuantity = Rand_Item.dices[0] #+ min_bonus_to_characteristic  #Rand_Item.dice + (1 * int(Stage_level / 3)) if rarity == 'rare' else Rand_Item.dice + (1 * int(Stage_level / 2))
		Rand_Item.dice = Rand_Item.dices[1] # + (1 * int(Stage_level / 2)) if rarity == 'rare' else Rand_Item.dice + (1 * int(Stage_level / 1.5))
			
		Rand_Item.dices = [Rand_Item.dicesQuantity, Rand_Item.dice]
		
	elif Item_cat == 'Armors' :
		var Armor_char = ['Armor', 'Health', 'Strength']
		num_of_characteristis -= 1 
		Rand_Item.affectations['Armor'] = affectation_to_char(Stage_level, Rand_Item.rarity) #rng.randi_range(Stage_level, Aeternus.HERO.Level)
		Rand_Item.bonus_afect_to.push_back('Armor')
		if Rand_Item.class == 'shield' :
			Rand_Item.affectations['Absorption'] = affectation_to_char(Stage_level, Rand_Item.rarity)
			Rand_Item.bonus_afect_to.push_back('Absorption')
		Rand_Item.dices = [Rand_Item.dicesQuantity + Rarity_elements[Rand_Item.rarity].min_bonus_to_characteristic , Rand_Item.dice + (Rarity_elements[Rand_Item.rarity].min_characteristic_bonus - 1) ]
		Rand_Item.defense = Aeternus.dice_through(Rand_Item.dices[0],  Rand_Item.dices[1])
		Rand_Item.defenseBonus = Rarity_elements[Rand_Item.rarity].min_characteristic_bonus
		#Ported_Armor.defense + Ported_Armor.defenseBonus 
			
	while num_of_characteristis > 0:
		var char = CHAR_AFFECTATION[rng.randi() % CHAR_AFFECTATION.size()]
		if !affected_char.has(char) :
			Rand_Item.bonus_afect_to.push_back(char)	
			num_of_characteristis -= 1
		else : ## ya tiene la característica 
			if rarity != 'epic': 
				Rand_Item.bonus_afect_to.push_back(char)	
				num_of_characteristis -= 1
	
	for charac in Rand_Item.bonus_afect_to :
		if Rand_Item.affectations.has(charac) :
			Rand_Item.affectations[charac] += rng.randi_range(Stage_level, (Aeternus.HERO.Level + Stage_level)) 
		else :
			Rand_Item.affectations[charac] = rng.randi_range(Stage_level, (Aeternus.HERO.Level + Stage_level))		
	
	Rand_Item.unique_id = generate_unique_ID(Rand_Item.name)
	#print(Rand_Item.unique_id)
	
	return Rand_Item

func key_generator(Category, type, Key_unique_code):
	#print('key_generator')
	var Stage_level = Aeternus.Stage_level
	var THE_KEY = Keys_DB[type].duplicate(true)
	#print(THE_KEY)
	THE_KEY.unique_id = generate_unique_ID(THE_KEY.name)
	if type == 'Single Key' :
		THE_KEY['open_code'] = [Key_unique_code] #if type == 'Single Key' else 00
	elif type == 'Master Key' :
		THE_KEY['open_code'] = [369]
	else :
		THE_KEY['open_code'] = [00]
	return THE_KEY

func compile_returned_item(THING) :
	#print(THING)
	#print('compile_returned_item')
	return THING 
