extends TextureRect
 
@onready var inventory = $".."

var items_store = []
 
var ShopStore = {}

var store_grid = {}
var cell_size = 20
var store_grid_width = 0
var store_grid_height = 0
 
func _ready():
	var s = get_grid_size(self)
	store_grid_width = s.x
	store_grid_height = s.y
 
	for x in range(store_grid_width):
		store_grid[x] = {}
		for y in range(store_grid_height):
			store_grid[x][y] = false
 
func set_shop() :
	for item in ShopStore :
		print('item --------->>>>>>> ', item)
		inventory.pickup_item(item, ShopStore)

func insert_item(item):
	var item_pos = item.global_position + Vector2(cell_size / 2, cell_size / 2)
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size = get_grid_size(item)
	if is_grid_space_available(g_pos.x, g_pos.y, item_size.x, item_size.y):
		set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, true)
		item.global_position = global_position + Vector2(g_pos.x, g_pos.y) * cell_size
		
		## Belt slot to remove
		if str(item.get_parent().name).find("BeltSlot") > -1 :
			item.reparent(get_parent())
			BackPack.Back_Pack[item.get_meta('id')]['is_in_belt'] = null
		
		items_store.append(item)
		items_store = clean_Array(items_store)
		return true
		
	elif get_item_under_pos(item_pos) != null :
		print('Aqui está ocupado pero intentaremos ponerlo y cambiarlo')
		if item.get_meta('stackable') :
			print('potion or another stuff, scroll or something like that')
			var hold_item_id_arr = item.get_meta('id').split("_", false, 2)
			var hold_item_id = hold_item_id_arr[0] + hold_item_id_arr[1]
			var base_item_id_arr = get_item_under_pos(item_pos).get_meta('id').split("_", false, 2)
			var base_item_id = base_item_id_arr[0] + base_item_id_arr[1]
			var hold_item_stackable = item.get_meta('stackable')
			var base_item_stackable = get_item_under_pos(item_pos).get_meta('stackable')
			if item.get_meta('id') != null && hold_item_id == base_item_id && hold_item_stackable && base_item_stackable :
				return stacking_items(item, get_item_under_pos(item_pos))
		else :
			print("It isn't stackable")
			#print(item.size)
			var in_slot_item = get_item_under_pos(item_pos)
			#print(in_slot_item.size)
			if item.size == in_slot_item.size :
				print('at least they are the same size, good')
				#item.global_position = in_slot_item.global_position
				#set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, true)
				#in_slot_item = grab_item(item_pos)
				#inventory.item_held = in_slot_item
			#return true	
		
	else :
		#print('No mas espacio disponible')
		return false
func check_if_stakable():
	pass		

func stacking_items(hold_Item, base_Item):
	#return Aeternus.Stack_Items(hold_Item, base_Item)
	print(hold_Item)
	var base_ItemStack = 1
	var newStack
	var restantStack
	#if !base_Item.has_meta("stack"):
		#base_Item.set_meta("stack", base_ItemStack )
	#else :
	base_ItemStack = 	base_Item.get_meta("stack")
	var HoldItemStack = hold_Item.get_meta("stack") if hold_Item.has_meta("stack") else 1
	
	if HoldItemStack == 10 :
		return false
	
	#if base_Item.name.contains('_key_') :
		#
		#if base_Item.name.contains('single_key_') :
			#pass
		#elif base_Item.name.contains('master_key_') : 
			#pass
		#elif base_Item.name.contains('normal_key_') :
			#pass
		#
		#return true
	
	if base_ItemStack <= 9 :
		newStack = base_ItemStack + HoldItemStack
		var rest_added_to_base = 10 - base_ItemStack
		if newStack > 10 :
			base_ItemStack = 10
			restantStack = newStack - base_ItemStack 
			var  restant_text = str(restantStack) if restantStack > 1 else ""
			if base_Item.name.contains('_key_') :
				if base_Item.name.contains('single_key_')  :
					var new_holded_array = BackPack.Back_Pack[hold_Item.name]['open_code'].duplicate(true)
					var codes_package_to_add = BackPack.Back_Pack[hold_Item.name]['open_code'].slice(0, rest_added_to_base)
					BackPack.Back_Pack[base_Item.name]['open_code'].append_array(codes_package_to_add)
					BackPack.Back_Pack[hold_Item.name]['open_code'] = new_holded_array.slice(rest_added_to_base, new_holded_array.size())
			set_label_and_meta(base_Item, hold_Item, base_ItemStack, restantStack)
			return false 
		elif newStack <= 10 :
			if base_Item.name.contains('_key_') :
				if base_Item.name.contains('single_key_') :
					print('Old Base Array -> ', BackPack.Back_Pack[base_Item.name]['open_code'] )
					BackPack.Back_Pack[base_Item.name]['open_code'].append_array(BackPack.Back_Pack[hold_Item.name]['open_code']) #array
					print('New Base Array -> ', BackPack.Back_Pack[base_Item.name]['open_code'] )
			BackPack.Back_Pack.erase(hold_Item.name)
			hold_Item.queue_free()
			set_label_and_meta(base_Item, null, newStack, null)
			return true
	else :
		return false	

func set_label_and_meta(base_item, held_item, new_stock, rest_stock):
	base_item.set_meta("stack", new_stock)
	base_item.get_node('Label').set_text(str(new_stock))
	BackPack.Back_Pack[base_item.name]['stock'] = new_stock
	BackPack.Back_Pack[base_item.name]['stack'] = new_stock
	if held_item != null :
		held_item.set_meta("stack", rest_stock)
		held_item.get_node('Label').set_text(str(rest_stock))
		BackPack.Back_Pack[held_item.name]['stock'] = rest_stock
		BackPack.Back_Pack[held_item.name]['stack'] = rest_stock
 
func remove_from_items(item) :
	for it in items_store :
		if it.name == item.name :
			items_store.remove_at(items_store.find(it))
	
func grab_item(pos):
	print('grab_item -> ', pos)
	if BackPack.INVENTORY_IS_VISIBLE :
		var item = get_item_under_pos(pos)
		if item == null:
			return null
		var item_pos = item.global_position + Vector2(cell_size / 2, cell_size / 2)
		var g_pos = pos_to_grid_coord(item_pos)
		var item_size = get_grid_size(item)
		set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, false)
		items_store.remove_at(items_store.find(item))
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
	if x + w > store_grid_width or y + h > store_grid_height:
		return false
	for i in range(x, x + w):
		for j in range(y, y + h):
			if store_grid[i][j]:
				return false
	return true
 
func set_grid_space(x, y, w, h, state):
	for i in range(x, x + w):
		for j in range(y, y + h):
			store_grid[i][j] = state
 
func get_item_under_pos(pos):
	for item in items_store:
		if item.get_global_rect().has_point(pos):
			return item
	return null
 
func insert_item_at_first_available_spot(item, rl = false , merch_pack = null):
	print('insert_item_at_first_available_spot')
	var Pack = merch_pack if merch_pack != null else BackPack.Back_Pack
	### Aqui cambié todos los "item.name" por -> item.id
	#print('Aqui cambié todos los "item.name" por -> ')
	## Es más seguro, porque cuando han estado en el cinturón, éstos cambian de nombre. 
	var item_id = item.get_meta('id')
	if  item_id.contains('_potion_'):
		Pack[item_id].stock = int(Pack[item_id].stock)
		if Pack[item_id].stack > 1 :
			if !item.has_meta("stack"):
				item.set_meta("stack", Pack[item_id].stack )
			if item.get_node('Label') != null :
				var label = item.get_node('Label')
				label.text = str(Pack[item_id].stack)
				label.position = Vector2(4,2)
		if Pack[item_id].has('is_in_belt') :
			if  Pack[item_id]['is_in_belt'] != null :
				var belt = get_parent().get_node(Pack[item_id]['is_in_belt'])
				belt.insert_after_reload(item)
				return true
				
	if Pack[item.name].has('occupied_slot') :
		if Pack[item.name] != null and Pack[item.name].occupied_slot != null:
			equiped.insert_after_load(item, Pack[item.name].occupied_slot)
			return true
	
	for y in range(store_grid_height):
		for x in range(store_grid_width):
			if !store_grid[x][y]:
				item.global_position = global_position + Vector2(x, y) * cell_size
				if insert_item(item):
					return true
	return false

func clean_Array(dirty_array: Array) -> Array:
	var clean_array := []
	for item in dirty_array:
		if is_instance_valid(item):
			clean_array.append(item)
	return clean_array
