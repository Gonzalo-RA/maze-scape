extends Panel

@onready var slots = get_children()

var items = {}

var busy = false
 
func _ready():
	for slot in slots:
		items[slot.name] = null

func insert_item(item):
	
	#print(item)
	var item_pos = item.global_position + item.size / 2
	var slot = get_slot_under_pos(item_pos)
	var item_slot = BackPack.get_item(item.get_meta("id"))["slot"]
	var item_name_id = item.get_meta('id')
	var hold_item_id_arr = item_name_id.split("_", false, 2)
	var hold_item_id = hold_item_id_arr[0] + hold_item_id_arr[1]
	#print(hold_item_id)
	#print(item_name_id)
	#var base_item_id_arr = get_item_under_pos(item_pos).get_meta('id').split("_", false, 2)
	#var base_item_id = base_item_id_arr[0] + base_item_id_arr[1]
	
	if str(item_slot) != "IN_BELT" || slot == null :
		return false
	
	#print('aqui hacer otra peripecia para juntarlos ')
	if busy && get_item_under_pos(item_pos):
		if BackPack.get_item(item.get_meta("id"))["name"] == BackPack.get_item(get_item_under_pos(item_pos).get_meta("id"))["name"] :	
			stacking_items(get_item_under_pos(item_pos), item)
			return false
		else :
			return false

	var stack = int(item.get_children()[0].get_text()) if !item.get_children().is_empty() else 1
	#print(stack)
	item.reparent(self)
	#print('Maybe here in .... reparent (self) ?? ')

	if item.get_children().is_empty():
		var label = Label.new()
		label.position = Vector2(0,0)
		label.set_text(str(''))
		item.add_child(label)
		
	item_slot = item_slot + '_s_' + str(stack) + '_x_' + item_name_id #BackPack.get_item(item.get_meta("id"))["name"]	
	item.name = BackPack.get_item(item.get_meta("id"))["name"]
	item.set_meta('name_id', item_name_id)
	#print('Aqui tal vez debiera revista el BackPack...')
	#print('Es posible que deba borrar el item en el Back Pack y sumarlo nuevamente')
	item.set_meta('name', BackPack.get_item(item.get_meta("id"))["name"])
	items[item_slot] = item
	items[item_slot].global_position = slot.global_position + slot.size / 2 - item.size / 2
	items[item_slot].set_meta('name_id', item_name_id)
	busy = true
	#print(item_slot)
	return true

func stacking_items(base_Item, hold_Item):
	var new_Stack
	var restant_Stack
	var base_Item_Stack = int(base_Item.get_children()[0].get_text()) if !base_Item.get_children().is_empty() && base_Item.get_children()[0].get_text() != '' else 1
	var hold_Item_Stack = int(hold_Item.get_children()[0].get_text()) if !hold_Item.get_children().is_empty() && hold_Item.get_children()[0].get_text() != '' else 1
	if hold_Item_Stack == 10 :
		return false
	if base_Item_Stack <= 9:
		new_Stack =  base_Item_Stack + hold_Item_Stack
		if new_Stack > 10:
			base_Item_Stack = 10
			restant_Stack = new_Stack - base_Item_Stack
			var  restant_text = str(restant_Stack) if restant_Stack > 1 else ""
			base_Item.set_meta('stack', base_Item_Stack)
			base_Item.get_children()[0].set_text(str(base_Item_Stack))
			hold_Item.set_meta('stack', restant_Stack)
			hold_Item.get_children()[0].set_text(restant_text)
			return false
		elif new_Stack <= 10 :
			base_Item.set_meta('stack', new_Stack)
			if base_Item.get_children().is_empty():
				var label = Label.new()
				label.position = Vector2(4,2)
				label.set_text(str(new_Stack))
				#label.set_horizontal_alignment(2)
				base_Item.add_child(label)
			base_Item.get_children()[0].set_text(str(new_Stack))
			base_Item.get_children()[0].set_position(Vector2(4,2))	
			hold_Item.queue_free()
			return true
	else :
		return false	

func get_slot_under_pos(pos):
	return get_thing_under_pos(slots, pos)
	
func get_thing_under_pos(arr, pos):
	for thing in arr:
		if thing != null and thing.get_global_rect().has_point(pos):
			return thing
	return null
	
func grab_item(pos):
	var item = get_item_under_pos(pos)
	if item == null:
		return null
	items.erase(items.keys()[1])
	busy = false
	return item
 
func get_item_under_pos(pos):
	return get_thing_under_pos(items.values(), pos)
