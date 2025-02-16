extends TextureRect
 
var items = []
 
var grid = {}
var cell_size = 20
var grid_width = 0
var grid_height = 0
 
func _ready():
	var s = get_grid_size(self)
	grid_width = s.x
	grid_height = s.y
 
	for x in range(grid_width):
		grid[x] = {}
		for y in range(grid_height):
			grid[x][y] = false
 
func insert_item(item):
	var item_pos = item.global_position + Vector2(cell_size / 2, cell_size / 2)
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size = get_grid_size(item)
	if is_grid_space_available(g_pos.x, g_pos.y, item_size.x, item_size.y):
		set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, true)
		item.global_position = global_position + Vector2(g_pos.x, g_pos.y) * cell_size
		if str(item.get_parent().name).find("BeltSlot") > -1 :
			item.reparent(get_parent())
		items.append(item)
		items = clean_Array(items)
		return true
		
	elif get_item_under_pos(item_pos) != null :
		print('Aqui está ocupado pero intentaremos ponerlo y cambiarlo')
		var hold_item_id_arr = item.get_meta('id').split("_", false, 2)
		#print(hold_item_id_arr)
		var hold_item_id = hold_item_id_arr[0] + hold_item_id_arr[1]
		var base_item_id_arr = get_item_under_pos(item_pos).get_meta('id').split("_", false, 2)
		var base_item_id = base_item_id_arr[0] + base_item_id_arr[1]
		
		var hold_item_stackable = item.get_meta('stackable')
		var base_item_stackable = get_item_under_pos(item_pos).get_meta('stackable')
		if item.get_meta('id') != null && hold_item_id == base_item_id && hold_item_stackable && base_item_stackable :
			return stacking_items(item, get_item_under_pos(item_pos))
	else :
		#print('No mas espacio disponible')
		return false
func check_if_stakable():
	pass		

func stacking_items(hold_Item, base_Item):
	#return Aeternus.Stack_Items(hold_Item, base_Item)
	var base_ItemStack = 1
	var newStack
	var restantStack
	#print(hold_Item)
	if !base_Item.has_meta("stack"):
		base_Item.set_meta("stack", base_ItemStack )
	else :
		base_ItemStack = 	base_Item.get_meta("stack")
	var HoldItemStack = hold_Item.get_meta("stack") if hold_Item.has_meta("stack") else 1
	if HoldItemStack == 10 :
		return false
	if base_ItemStack <= 9 :
		newStack = base_ItemStack + HoldItemStack
		if newStack > 10 :
			base_ItemStack = 10
			restantStack = newStack - base_ItemStack 
			var  restant_text = str(restantStack) if restantStack > 1 else ""
			hold_Item.set_meta("stack", restantStack)
			hold_Item.get_children()[0].set_text(restant_text)
			base_Item.set_meta("stack", base_ItemStack)
			base_Item.get_children()[0].set_text(str(base_ItemStack))
			return false 
		
		elif newStack <= 10 :
			base_Item.set_meta("stack", newStack)
			if base_Item.get_children().is_empty() :
				var label = Label.new()
				label.position = Vector2(4,2)
				label.set_text(str(newStack))
				base_Item.add_child(label)
			base_Item.get_children()[0].set_text(str(newStack))	
			hold_Item.queue_free()
			base_Item.get_children()[0].set_position(Vector2(4,2))
			#print('Hola Label Stacking ')
			return true
	else :
		return false	
	#
 
func remove_from_items(item) :
	for it in items :
		if it.name == item.name :
			items.remove_at(items.find(it))
	
func grab_item(pos):
	if BackPack.INVENTORY_IS_VISIBLE :
		var item = get_item_under_pos(pos)
		if item == null:
			return null
		var item_pos = item.global_position + Vector2(cell_size / 2, cell_size / 2)
		var g_pos = pos_to_grid_coord(item_pos)
		var item_size = get_grid_size(item)
		set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, false)
		items.remove_at(items.find(item))
		return item
 
func pos_to_grid_coord(pos):
	var local_pos = pos - global_position
	var results = {}
	results.x = int(local_pos.x / cell_size)
	results.y = int(local_pos.y / cell_size)
	return results
 
func get_grid_size(item):
	var results = {}
	var s = item.size
	results.x = clamp(int(s.x / cell_size), 1, 125)
	results.y = clamp(int(s.y / cell_size), 1, 125)

	return results
 
func is_grid_space_available(x, y, w ,h):
	if x < 0 or y < 0:
		return false
	if x + w > grid_width or y + h > grid_height:
		return false
	for i in range(x, x + w):
		for j in range(y, y + h):
			if grid[i][j]:
				return false
	return true
 
func set_grid_space(x, y, w, h, state):
	for i in range(x, x + w):
		for j in range(y, y + h):
			grid[i][j] = state
 
func get_item_under_pos(pos):
	for item in items:
		if item.get_global_rect().has_point(pos):
			return item
	return null
 
func insert_item_at_first_available_spot(item, rl = false):
	if BackPack.Back_Pack[item.name].has('occupied_slot') :
		if BackPack.Back_Pack[item.name] != null and BackPack.Back_Pack[item.name].occupied_slot != null:
			#print('AQUI INSERTAR EN EQUIPED Y NO EN GRID ')
			equiped.insert_after_load(item, BackPack.Back_Pack[item.name].occupied_slot)
			return true
	for y in range(grid_height):
		for x in range(grid_width):
			if !grid[x][y]:
				item.global_position = global_position + Vector2(x, y) * cell_size
				if insert_item(item):
					#print('ITEM INSERTADO')
					return true
	return false

func clean_Array(dirty_array: Array) -> Array:
	var clean_array := []
	for item in dirty_array:
		if is_instance_valid(item):
			clean_array.append(item)
	return clean_array
