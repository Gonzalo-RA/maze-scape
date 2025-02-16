extends Node

var INVENTORY_UPDATED = false
var INVENTORY_IS_VISIBLE = false
var INVENTORY_TO_RELOAD = false

@onready var Inventario = $"."

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
	#print('por qui add to bag ')
	#var new_item_n add tame_key = item.unique_id #if item.itemClass != 'potion' else item.name
	Back_Pack[item.unique_id] = item 
	new_item = item
	if Aeternus.Inventory.pickup_item(item.unique_id) :
		print('por qui si funciona -> ', item.unique_id)
	else :
		Back_Pack.erase(Back_Pack[item.unique_id])
		#print('por qui no funciona')
		#print('Erase -> ', item.unique_id)
		return false
	
	#INVENTORY_UPDATED = true

#func re_load_BACKPACK(item_to_reload):
	#print('re_load_BACKPACK')
	##for item in Back_Pack :
		##new_item = item
		##print(Back_Pack[item]['unique_id'])
	
func get_the_new_item(_new_itemm):
	pass

func get_item(item_id) :
	if item_id in Back_Pack :
		return Back_Pack[item_id]
	else :
		return Back_Pack["error"]

#func delete_Items():
	#item_held.queue_free()
	#item_held = null
	#to_drop = false
