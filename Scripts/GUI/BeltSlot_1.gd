extends Panel

@onready var slots = get_children()

#@onready var Inventory = $".."

var items = {}

var busy = false
 
func _ready():
	for slot in slots:
		items[slot.name] = null
func _process(delta):
	pass
func insert_item(item):
	var item_pos = item.global_position + item.size / 2
	var slot = get_slot_under_pos(item_pos)
	var item_slot = BackPack.get_item(item.get_meta("id"))["slot"]
	if str(item_slot) != "IN_BELT" || slot == null :
		return false
	var item_name_id = item.get_meta('id')
	var hold_item_id_arr = item_name_id.split("_", false, 2)
	var hold_item_id = hold_item_id_arr[0] + hold_item_id_arr[1]
	if busy && get_item_under_pos(item_pos):
		if BackPack.get_item(item.get_meta("id"))["name"] == BackPack.get_item(get_item_under_pos(item_pos).get_meta("id"))["name"] :	
			return stacking_items(get_item_under_pos(item_pos), item)
		else :
			return false

	var stack = int(item.get_node('Label').get_text()) if item.get_node('Label').get_text() != '' else 1
	item.reparent(self)
	BackPack.get_item(item.get_meta("id"))['is_in_belt'] = self.name
	item_slot = item_slot + '_s_' + str(stack) + '_x_' + item_name_id #BackPack.get_item(item.get_meta("id"))["name"]	
	item.name = BackPack.get_item(item.get_meta("id"))["name"]
	item.set_meta('name_id', item_name_id)
	item.set_meta('name', BackPack.get_item(item.get_meta("id"))["name"])
	items[item_slot] = item
	items[item_slot].global_position = slot.global_position + slot.size / 2 - item.size / 2
	items[item_slot].set_meta('name_id', item_name_id)
	busy = true
	return true

func insert_after_reload(item):
	var item_slot = BackPack.get_item(item.get_meta("id"))["slot"]
	var item_name_id = item.get_meta('id')
	var hold_item_id_arr = item_name_id.split("_", false, 2)
	var hold_item_id = hold_item_id_arr[0] + hold_item_id_arr[1]
	var stack = int(item.get_node('Label').get_text()) if item.get_node('Label').get_text() != '' else 1
	item.reparent(self)
	BackPack.get_item(item.get_meta("id"))['is_in_belt'] = self.name
	item_slot = item_slot + '_s_' + str(stack) + '_x_' + item_name_id #BackPack.get_item(item.get_meta("id"))["name"]	
	item.name = BackPack.get_item(item.get_meta("id"))["name"]
	item.set_meta('name_id', item_name_id)
	item.set_meta('name', BackPack.get_item(item.get_meta("id"))["name"])
	items[item_slot] = item
	items[item_slot].global_position = self.global_position + self.size / 2 - item.size / 2
	items[item_slot].global_position.y = items[item_slot].global_position.y - 109
	self.show()
	items[item_slot].set_meta('name_id', item_name_id)

	busy = true
	return true

func stacking_items(base_Item, hold_Item):
	var new_Stack
	var restant_Stack
	var base_Item_Stack = int(base_Item.get_node('Label').get_text()) if base_Item.get_node('Label').get_text() != '' else 1
	var hold_Item_Stack = int(hold_Item.get_node('Label').get_text()) if hold_Item.get_node('Label').get_text() != '' else 1 # !hold_Item.get_children().is_empty() && 
	if hold_Item_Stack == 10 :
		return false
	if base_Item_Stack <= 9:
		new_Stack =  base_Item_Stack + hold_Item_Stack
		if new_Stack > 10:
			base_Item_Stack = 10
			restant_Stack = new_Stack - base_Item_Stack
			var  restant_text = str(restant_Stack) if restant_Stack > 1 else ""
			set_label_and_meta(base_Item, hold_Item, base_Item_Stack, restant_Stack)
			#base_Item.set_meta('stack', base_Item_Stack)
			#base_Item.get_children()[0].set_text(str(base_Item_Stack))
			#hold_Item.set_meta('stack', restant_Stack)
			#hold_Item.get_children()[0].set_text(restant_text)
			#print('im here')
			#BackPack.Back_Pack[base_Item.get_meta('id')]['stock'] = base_Item_Stack
			#BackPack.Back_Pack[base_Item.get_meta('id')]['stock'] = restant_Stack
			#BackPack.Back_Pack[base_Item.get_meta('id')]['stack'] = base_Item_Stack
			#BackPack.Back_Pack[base_Item.get_meta('id')]['stack'] = restant_Stack
			return false
		elif new_Stack <= 10 :
			#print('again')
			#base_Item.set_meta('stack', new_Stack)
			#if base_Item.get_children().is_empty():
				#var label = Label.new()
				#label.position = Vector2(4,2)
				#label.set_text(str(new_Stack))
				##label.set_horizontal_alignment(2)
				#base_Item.add_child(label)

			BackPack.Back_Pack.erase(hold_Item.get_meta('id'))
			hold_Item.queue_free()
			set_label_and_meta(base_Item, null, new_Stack, null)
			#base_Item.get_children()[0].set_text(str(new_Stack))
			#base_Item.get_children()[0].set_position(Vector2(4,2))
			#BackPack.Back_Pack[base_Item.get_meta('id')]['stock'] = new_Stack
			#BackPack.Back_Pack[base_Item.get_meta('id')]['stack'] = new_Stack
			return true
	else :
		return false
		
func set_label_and_meta(base_item, held_item, new_stock, rest_stock):
	base_item.set_meta("stack", new_stock)
	base_item.get_node('Label').set_text(str(new_stock))
	BackPack.Back_Pack[base_item.get_meta('id')]['stock'] = new_stock
	BackPack.Back_Pack[base_item.get_meta('id')]['stack'] = new_stock
	if held_item != null :
		held_item.set_meta("stack", rest_stock)
		held_item.get_node('Label').set_text(str(rest_stock))
		BackPack.Back_Pack[held_item.get_meta('id')]['stock'] = rest_stock
		BackPack.Back_Pack[held_item.get_meta('id')]['stack'] = rest_stock		

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
	### Ojo aquí puede estar causando un problema y no se pueden "hold items"	
	items.erase(items.keys()[1])
	busy = false
	return item
 
func get_item_under_pos(pos):
	return get_thing_under_pos(items.values(), pos)
