extends Node

var INVENTORY_UPDATED = false
var INVENTORY_IS_VISIBLE = false
var INVENTORY_TO_RELOAD = false

@onready var Inventario = $"."

const ICON_PATH = "res://Assets/Images/Items/"

var Back_Pack = {}
var cinturon = {}
var Important_Items = {}
#var new_item 

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
	
	#var Pack = merch_backpack if merch_backpack != null else Back_Pack
	#var Inventory = 'Inventory' if merch_backpack == null else 'Merchant_Inventory'
	#Pack[item.unique_id] = item 
	#if !Aeternus[Inventory].pickup_item(item.unique_id, merch_backpack) :
		#Pack.erase(Pack[item.unique_id])
		#return false
	
		## antiguo ##
	Back_Pack[item.unique_id] = item 
	if !Aeternus.Inventory.pickup_item(item.unique_id) :
		Back_Pack.erase(Back_Pack[item.unique_id])
		return false
	
	##if merch_backpack != null:
		#print('is merchant')
		#merch_backpack[item.unique_id] = item 
		##print(merch_backpack)
		##Aeternus.Merchant_Inventory.pickup_item(item.unique_id, merch_backpack)
	##else :
		##Pack[item.unique_id] = item 
		##if !Aeternus.Inventory.pickup_item(item.unique_id, merch_backpack) :
			##Back_Pack.erase(Back_Pack[item.unique_id])
			##Pack.erase(Pack[item.unique_id])
			##return false
			

	
	

func get_item(item_id) :
	if item_id in Back_Pack :
		return Back_Pack[item_id]
	else :
		return Back_Pack["error"]

