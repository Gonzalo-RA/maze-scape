extends Panel
class_name equiped
 
@onready var slots = get_children()
static var SLOTS 
static var items = { 
				"WEAPON": null ,
				"SHIELD": null ,
				"CHEST": null ,
				"HEAD": null ,
				"RING_1": null ,
				"RING_2": null ,
				"GLOVES": null ,
				"FETISH": null ,
				"FEET": null ,
				"BELT": null ,
				"NECKLACE_1": null ,
				"NECKLACE_2": null ,
}

const item_base = preload("res://Scenes/UI/item_base.tscn")
@onready var returned_item = preload('res://Scenes/map_items/returned_item.tscn')
@onready var inventary = $".."

static var items_position = { 
				"WEAPON": null ,
				"SHIELD": null ,
				"CHEST": null ,
				"HEAD": null ,
				"RING_1": null ,
				"RING_2": null ,
				"GLOVES": null ,
				"FETISH": null ,
				"FEET": null ,
				"BELT": null ,
				"NECKLACE_1": null ,
				"NECKLACE_2": null ,
}

func _ready():
	SLOTS = slots
	for slot in SLOTS:
		items_position[slot.name] =  slot.position
	#print(items_position)	
 
func insert_item(item):
	#print('insert item // Equiped.gd')
	var item_pos = item.global_position + item.size / 2
	var slot = get_slot_under_pos(item_pos)
	if slot == null:
		return false
	var item_slot = BackPack.get_item(item.get_meta("id"))["slot"]
	if !slot.name.begins_with(item_slot.substr(0,4)) :
		print('No puedes vestir un casco como zapatos')
		return false
	if items[slot.name] != null:
		if slot.name.begins_with(item_slot.substr(0,4)) :
			print('Here exchange item, give the held one and I ll give you the stored one.')
			#var in_slot_item = items[slot.name]
			#items[slot.name] = item
			#item.set_meta('occupied_slot', slot.name )
			#BackPack.Back_Pack[item.get_meta("name")].occupied_slot = str(slot.name)
			#BackPack.Back_Pack[in_slot_item.get_meta("name")].occupied_slot = null
			##item_held =  in_slot_item
			#item.global_position = slot.global_position + slot.size / 2 - item.size / 2
			##in_slot_item.occupied_slot = null
			#Aeternus.remove_ported_item(in_slot_item)
			#hero_data.wear_items(item)
			return false
		return false
		
	item.set_meta('occupied_slot', slot.name )
	BackPack.Back_Pack[item.get_meta("name")].occupied_slot = str(slot.name)
	items[slot.name] = item
	item.global_position = slot.global_position + slot.size / 2 - item.size / 2
	hero_data.wear_items(item)
	return true

static func insert_after_load(item, slot):
	for sl in SLOTS :
		if sl.name == BackPack.Back_Pack[item.name].occupied_slot :
			items[sl.name] = item
			item.global_position = sl.global_position + sl.size / 2 - item.size / 2
			hero_data.wear_items(item)
	

static func load_equiped_slots():
	print('- load_equiped_slots - ')
	for reload_it in items :
		if items[reload_it] != null :
			var reloaded_item = item_base.instantiate()
			var the_item_name = items[reload_it].get_slice(':',0)
			##print(hero_data.Equiped_Items[the_item_name])
			reloaded_item.set_meta("id", the_item_name)
			reloaded_item.texture = load(hero_data.Equiped_Items[the_item_name]['icon_inventary']) 
			reloaded_item.name = the_item_name #BackPack.get_item(item_id)["name"]
			reloaded_item.set_meta('stackable', hero_data.Equiped_Items[the_item_name]['stackable'])
			reloaded_item.set_meta('name', the_item_name)
			#print('AHORA SI : -> ' , the_item_name)
			items[reload_it] = reloaded_item
			#inventary.add_child(reloaded_item)
			#print(get_parent())
		else :
			pass
			#print(reload_it)	
	#print(items)
 

func grab_item(pos):
	if BackPack.INVENTORY_IS_VISIBLE:
		var item = get_item_under_pos(pos)
		if item == null:
			return null
		var item_slot =  BackPack.Back_Pack[item.name].occupied_slot 
		BackPack.Back_Pack[item.name].occupied_slot = null
		items[item_slot] = null
		hero_data.remove_item(item)
		return item
 
func get_slot_under_pos(pos):
	return get_thing_under_pos(slots, pos)
 
func get_item_under_pos(pos):
	return get_thing_under_pos(items.values(), pos)
 
func get_thing_under_pos(arr, pos):
	for thing in arr:
		if thing != null and thing.get_global_rect().has_point(pos):
			return thing
	return null
	
static func delete_return_items():
	for it_to_del in items  :
			if items[it_to_del] :
				var clon = items[it_to_del].duplicate() 
				Aeternus.EQUIPED[it_to_del] = clon
				var itd = items[it_to_del]
				itd.queue_free()
				items[it_to_del] = null
