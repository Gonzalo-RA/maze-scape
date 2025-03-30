#@tool
extends Area2D
class_name items_maker
#export (String) var ID_number

enum LOOT_TYPE { COINS, GEMS, POTIONS, ARMORS, WEAPON, IMPLEMENTS, KEYS, AMULETS, SCROLLS, SPECIAL, RANDOM}

@export var Loot_Category : LOOT_TYPE
var Loot_list = [
	'Coins', 'Gems', 'Potions', 'Armors', 'Weapons', 'Implements', 'Keys', 'Amulets', 'Scrolls', 'Special', 'random',
	]	

@onready var Loot_category = Loot_list[Loot_Category]

@onready var Loot = Items_DB.GLOBAL_TREASURE_DICT[Loot_list[Loot_Category]]

@export var instance_ID = 100000000
@export var coin_value = 10 

@onready var DB_name = Loot.name + '_DB'

@export var Potion : Items_DB.POTIONS
@onready var Potion_list = Items_DB.Potions_name_list
@onready var Potion_ = Potion_list[Potion] if Potion > 0 else Potion_list[(Potion + 1)]
@export var Potion_Size : Items_DB.POTION_SIZE # {SMALL, MEDIUM, LARGE, EXTRA_LARGE}

@export var Armor : Items_DB.ARMORS
@onready var Armor_list = Items_DB.Armors_name_list

@export var Weapon : Items_DB.WEAPONS
@onready var Weapon_list = Items_DB.Weapons_name_list

@export var Implement : Items_DB.IMPLEMENTS
@onready var Implement_list = Items_DB.Implements_name_list

@export var Key : Items_DB.KEYS
@onready var Key_lists = Items_DB.Keys_name_list

@export var Key_unique_code = 100000000
#@export var Amulet : Items_DB.AMULETS
#@onready var Amulet_list = Items_DB.Amulets_name_list

@export var Special : Items_DB.SPECIAL
@onready var Special_list = Items_DB.special_name_list

var random_generated = false
var Random_Generated_Category
var Icon 
var rd_value #= RandomNumberGenerator.new() #(randi() % 20 + 1) * hero_data.Level
var ITEM
var Item_name

#var selection 

func _ready():
	randomize()
	rd_value = RandomNumberGenerator.new()
	if random_generated :
		Loot_category = Random_Generated_Category 
		if Loot_category != 'Gems' and  Loot_category != 'Scrolls':
			DB_name = Loot_category + '_DB'
	
	match Loot_category :
		'Coins' :
			coin_value = (rd_value.randi() % 20 + 1) * hero_data.Level #(hero_data.Level / 2)
			$sprite.set_frame_coords(Vector2i(0, 3))
		'Potions' :
			if random_generated :
				Potion_ = Potion_list[rd_value.randi_range(1, Potion_list.size() - 1)]
			Icon = Items_DB[DB_name][Potion_].icon
			ITEM = Items_DB.potion_maker(Items_DB[DB_name][Potion_].duplicate(true))
			$sprite.set_frame_coords(Vector2i(Icon[0], Icon[1]))
		'Gems' :
			pass
		'Armors' :
			if random_generated :
				Item_name = Armor_list[rd_value.randi_range(1, Armor_list.size() - 1)]
			else :
				Item_name = Armor_list[Armor] if Armor_list[Armor] != "Natural Armor" else Armor_list[1]
			Icon = Items_DB[DB_name][Item_name].icon
			ITEM = Items_DB.random_Item_Generator(Loot_category, Item_name) 
			$sprite.set_frame_coords(Vector2i(Icon[0],Icon[1]))
		'Weapons' :
			if random_generated :
				Item_name = Weapon_list[rd_value.randi_range(1, Weapon_list.size() - 1)]
			else :
				Item_name = Weapon_list[Weapon] if Weapon_list[Weapon] != null else Weapon_list[1]
			Icon = Items_DB[DB_name][Item_name].icon
			ITEM = Items_DB.random_Item_Generator(Loot_category, Item_name) # duplicate(true))
			$sprite.set_frame_coords(Vector2i(Icon[0],Icon[1]))
		'Amulets' :
			ITEM = Items_DB.random_Item_Generator(Loot_category)
			$sprite.set_frame_coords(Vector2i(0, 2))
		'Implements' :
			if random_generated :
				Item_name = Implement_list[rd_value.randi_range(1, Implement_list.size() - 1)]
			else :
				Item_name = Implement_list[Implement] if Implement_list[Implement] != null else Implement_list[1]
			Icon = Items_DB[DB_name][Item_name].icon
			ITEM = Items_DB.random_Item_Generator(Loot_category)
			$sprite.set_frame_coords(Vector2i(Icon[0],Icon[1]))
		'Keys' :
			if random_generated :
				Item_name = Key_lists[0] # [rd_value.randi_range(0,2)] # 
			else :
				Item_name = Key_lists[Key] if Key_lists[Key] != null else Key_lists[0]
			Icon = Items_DB[DB_name][Item_name].icon
			ITEM = Items_DB.key_generator(Loot_category, Item_name, Key_unique_code)
			$sprite.set_frame_coords(Vector2i(Icon[0],Icon[1]))
				
		'Scrolls' :	
			#ITEM = Items_DB[DB_name][Scroll_list[Scrolls]]
			pass
		'Special' :	
			#ITEM = Items_DB[DB_name][Special_list[Special]]
			pass
		'Random' :
			pass
	
func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == 'Hero':
		if Loot_category == 'Coins' : #|| Loot.name == 'Gems' || Loot.name == 'Keys' :
			#print('COINS')
			BackPack.Treasure[Loot.name] += coin_value
		else :
			if ITEM != null : #and Aeternus.Inventory.pickup_item(ITEM.unique_id):
				BackPack.add_to_bag(ITEM)
				#hero_data.emptpy_poquets = false
		queue_free()	
