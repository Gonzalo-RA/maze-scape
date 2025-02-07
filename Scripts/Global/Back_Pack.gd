extends Node

var INVENTORY_UPDATED = false
var INVENTORY_IS_VISIBLE = false

const ICON_PATH = "res://Assets/Images/Items/"

var Back_Pack = {}
var cinturon = {}
var Important_Items = {}
var new_item 

var Treasure = {
	'Coins': 0,
	'Gems': 0,
	'Potion': 0,
	'Armor': 0,
	'Weapon': 0,
	'Key': 0,
	'Scroll': 0,
}

func add_to_bag(item):
	#print('--------- ADD to BACG --- Back Pack')
	var new_item_name_key = item.unique_id #if item.itemClass != 'potion' else item.name
	Back_Pack[new_item_name_key] = item 
	new_item = item
	INVENTORY_UPDATED = true
	
func get_the_new_item(_new_itemm):
	pass

func get_item(item_id) :
	if item_id in Back_Pack :
		return Back_Pack[item_id]
	else :
		return Back_Pack["error"]

