extends Panel
 
@onready var slots = get_children()
var items = { 	"WEAPON": null ,
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
 
@onready var returned_item = preload('res://Scenes/map_items/returned_item.tscn')

func _ready():
	pass
	#for slot in slots:
	#	items[slot.name] = null

func _process(delta):

	if BackPack.return_equiped_items_ :
		return_items()
		
 
func insert_item(item):
	print('insert item // Equiped.gd')
	var item_pos = item.global_position + item.size / 2
	var slot = get_slot_under_pos(item_pos)
	print ('ultima llamada -> Equiped.gd -> insert_item(item):')
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


var Yoyo 
func _input(event):
	pass
	if Yoyo != null :
		if event is InputEventMouseButton:
			print("Mouse Click/Unclick at: ", event.position)
			print(Yoyo.name)
		elif event is InputEventMouseMotion:
			print("Mouse Motion at: ", event.position)
			Yoyo.global_position = event.position
			#print('YOYO P#osition : ', Yoyo.position )

func insert_item_after_load():
	print('insert_item_after_load')
	##for it in items :
		##items[it] = null	
	#print(items)
	#print('-----------')
	for item in items :
		if items[item] != null :
			 # [&"id", &"stackable", &"name", &"occupied_slot"]
			items[item].name = items[item].get_meta('name')
			Yoyo = items[item]
			#BackPack.Back_Pack[items[item].get_meta('name')].global_position
			for element_slot in slots :
				#print(element_slot)
				if element_slot.name == items[item].get_meta('occupied_slot') :
					##items.remove_at(items.find(item))
					items[item].global_position = element_slot.global_position + element_slot.size / 2 - items[item].size / 2
					for grd_itms in $"../Base_Grid".items :
						if grd_itms.name == items[item].name :
							pass
							
					#print($"../Base_Grid".items.find([items[item]])) # [items[item]].get_texture()
					##print(items[item])
					#$"../Base_Grid".remove_from_items(items[item])
					##print($"../Base_Grid".get_children())
					#print(BackPack.Back_Pack[items[item].name])
					#print($"../Base_Grid".items)
					## get_viewport().get_mouse_position()

					#print(items[item].global_position)
					#print(BackPack.Back_Pack)
					##get_thing_under_pos(slots, pos)
					
		#var item_pos = item.global_position + item.size / 2
		#var slot = get_slot_under_pos(item_pos)
		#var item_slot = BackPack.get_item(item.get_meta("id"))["slot"]
		#item.set_meta('occupied_slot', slot.name )
		#BackPack.Back_Pack[item.get_meta("name")].occupied_slot = str(slot.name)
		#items[slot.name] = item
		#item.global_position = slot.global_position + slot.size / 2 - item.size / 2
		#hero_data.wear_items(item)
		#print('ITEMS')
		#
	print(items)
	print('-----------')
 

func grab_item(pos):
	#print('GRAP POS')
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
func return_items():
	print('equiped ---- retun item')
	for it_to_del in items  :
			if items[it_to_del] :
				#for item in BackPack.Back_Pack :
				var itd = items[it_to_del]
				print('Hero.gd : 247 ', itd.name)
				#print(BackPack.Back_Pack[itd.name])
				
				var rd_value = RandomNumberGenerator.new()
				var the_thing = returned_item.instantiate()
				#print(BackPack.Back_Pack[it_to_del])
				the_thing.Data = BackPack.Back_Pack[itd.name]
				the_thing.position = global_position
				the_thing.position.x = global_position.x + randf_range(-10, 10)
				the_thing.position.y = global_position.y + randf_range(-10, 10) 
				get_tree().get_root().add_child(the_thing)
				print('HELLO?')
				
				
				print(itd)
				itd.queue_free()
				items[it_to_del] = null
				print(items[it_to_del])
				
	BackPack.return_equiped_items_ = false			
