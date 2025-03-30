extends Control

const item_base = preload("res://Scenes/UI/item_base.tscn")

@onready var inv_base = $Base
@onready var grid_bkpk = $Base_Grid
@onready var eq_slots = $Equiped
@onready var BigSlot = $Slot
@onready var BeltSlot1 = $BeltSlot_1
@onready var BeltSlot2 = $BeltSlot_2
@onready var BeltSlot3 = $BeltSlot_3
@onready var BeltSlot4 = $BeltSlot_4

@onready var ShopStore_base = $ShopStore
@onready var ShopStore_grid = $ShopStore_base_grid
#@onready var BeltSlot5 = $BeltSlot_5
@onready var Trash = $Trash
#@onready var Mochila = $Mochila

@onready var Item_info = $Item_Info

var item_held = null
var item_offset = Vector2()
var last_container = null
var last_pos =Vector2()

var inventory_on = false
var to_drop = false
var consumed = false
var is_reload = false
var is_merchant = false 
#var grid_x
#var grid_y

#'Merchant_Inventory'

var offset_up
var Belt_offset

func _ready():	

	#if name == 'Merchant_Inventory' :
		#is_merchant = true
		#Aeternus.ger_merchant_inventroy(self)
		##set_merchandise()
	#else :
	Aeternus.get_inventory(self)
	offset_up = get_offset(1)
	Belt_offset = BeltSlot1.get_offset(1)
	get_items_in_BackPack()


func get_items_in_BackPack() :
	#print('inventory_.gd : 40 // ', 'get_items_in_BackPack' )
	is_reload = true
	for Items in BackPack.Back_Pack:
		#print('in back pack ')
		#print(Items)
		pickup_item(Items)
	is_reload = false	

func set_merchandise(merch):
	print(merch)

func _process(_d):
	var cursor_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("inv_grab") :
		grab(cursor_pos)
	if Input.is_action_just_released("inv_grab"):
		release(cursor_pos)
	if item_held != null :
		item_held.global_position = cursor_pos + item_offset
	
	if inventory_on :
		show()
		set_offset(1, -93 )#offset_up)
		#if !is_merchant :
		belt_offset_on(BeltSlot1)
		belt_offset_on(BeltSlot2)
		belt_offset_on(BeltSlot3)
		belt_offset_on(BeltSlot4)
		#belt_offset_on(BeltSlot5)
		BackPack.INVENTORY_IS_VISIBLE = true
		
	elif !inventory_on	:
		BeltSlot1.show()
		set_offset(1, 124)
		belt_offset_off(BeltSlot1)
		belt_offset_off(BeltSlot2)
		belt_offset_off(BeltSlot3)
		belt_offset_off(BeltSlot4)
		#belt_offset_off(BeltSlot5)
		BackPack.INVENTORY_IS_VISIBLE = false

	if BackPack.INVENTORY_TO_RELOAD:
		for it_to_reload in BackPack.Back_Pack:
			pickup_item(BackPack.Back_Pack[it_to_reload]['unique_id'])	
		BackPack.INVENTORY_TO_RELOAD = false
		
func grab(cursor_pos):
	print('grab - inventory')
	var c = get_container_under_cursor(cursor_pos)
	if c != null and c.has_method("grab_item"):
		item_held = c.grab_item(cursor_pos)
		#print('item_held -> ', item_held)
		if item_held != null:
			var in_items = 'items' if c.name != 'ShopStore_base_grid' else 'items_store'
			for iin in c[in_items]:
				#print('iin > ',  iin)
				if c.name.find("BeltSlot") > -1 && str(iin).find(str(item_held.name)) > -1 :
					#print(str(item_held.name))
					c[in_items].erase(c.items.keys()[1])
			last_container = c
			#print('last_container -> ', last_container)
			last_pos = item_held.global_position
			item_offset = item_held.global_position - cursor_pos
			if to_drop:
				drop_item()
			elif consumed :
				BackPack.Back_Pack.erase(item_held.name)
				item_held.queue_free()
				consumed = false
			else :
				#print('Parent ' , item_held.get_parent().name)
				if item_held.get_parent().name != "Inventory_" :
					print(item_held.get_parent().name)
				else :
					#print('else')
					move_child(item_held, get_child_count())
		else :
			return false			

func _input(event):
	
	if event is InputEventMouseButton and event.is_double_click():
		var cursor_position = get_global_mouse_position()
		consume_item(cursor_position)
		
	if event.is_action_pressed("use_item_belt_slot_1"):
		consume_item(BeltSlot1.get_global_rect().get_center())
	if event.is_action_pressed("use_item_belt_slot_2"):
		consume_item(BeltSlot2.get_global_rect().get_center())
	if event.is_action_pressed("use_item_belt_slot_3"):
		consume_item(BeltSlot3.get_global_rect().get_center())
	if event.is_action_pressed("use_item_belt_slot_4"):
		consume_item(BeltSlot4.get_global_rect().get_center())
	#if event.is_action_pressed("use_item_belt_slot_5"):
		#consume_item(BeltSlot5.get_global_rect().get_center())

func consume_item(pos):
	#print('consume potion - (inventory)')
	var container = get_container_under_cursor(pos)
	if container != null and container.has_method("grab_item"):
		var stack
		var label
		var stock
		if container.name.contains('Base_Grid') :
			#print(' --- Base_Grid --- ')
			if BackPack.INVENTORY_IS_VISIBLE :
				for the_item in grid_bkpk.items:
					if the_item.get_global_rect().has_point(pos):
						if str(the_item.get_meta('name')).to_upper().contains('POTION') : ## esto porque las pociones ahora vienen con los nombres cambiados
							hero_data.drink_potion(the_item.get_meta('id'))
							stack = int(the_item.get_meta('stack'))
							stack -= 1
							if stack <= 0:
								consumed = true
								grab(pos)
								return
							else :
								stack = str("") if stack == 1 else stack
								the_item.set_meta("stack", stack)
								the_item.get_node('Label').set_text(str(stack))
								BackPack.Back_Pack[the_item.get_meta('id')].stock = int(stack)
								return
							pass
						else:
							return false				
		elif container.name.contains('BeltSlot') :
			#print(' ### In the BeltSlot #### ')
			for pot in container.items:
				if str(pot).to_upper().contains('POTION') :
					var the_item = BackPack.Back_Pack[pot.substr(pot.find('_x_') + 3)]
					var subsStack = pot.get_slice('_s_', 1)
					var theStack = subsStack.get_slice('_x_',0)
					var theLabel = container.get_child(1).get_children()
					the_item.stack = int(theStack)
					hero_data.drink_potion(the_item.unique_id)
					stack =  1 if theLabel[0].get_text() == '' else int(theLabel[0].get_text())	  # pot.stack if !lab.is_empty() else 1
					label = theLabel[0]
					stack -= 1
					if stack > 0 :
						the_item.stack = stack
						stack = "" if stack == 1 else str(stack)
						label.set_text(stack)
						#BackPack.Back_Pack[the.get_meta('name')].stock = stack
						the_item.stock = stack
						BackPack.Back_Pack[the_item.unique_id].stock = int(stack)
						return
					elif stack <= 0:
						consumed = true
						grab(pos)
						return
							
func release(cursor_pos):
	if item_held == null:
		return
	var c = get_container_under_cursor(cursor_pos)

	if c == null :
		return_item()
		return
	if c.name == "Trash" :
		print('FUERA!!!')
		drop_item()
		return
	if c.has_method("insert_item"):
		if c.insert_item(item_held):
			if last_container != c :
				if last_container.name == 'ShopStore_base_grid' :
					if !transaction('buy') :
						return_item()
				if c.name == 'ShopStore_base_grid' :
					if transaction('sell') :
						return_item()
			item_held = null
			print('No devuelto')
		else:
			print('returned ?????? ')
			return_item()
	else:
		return_item()

func get_container_under_cursor(cursor_pos):
	var containers = [grid_bkpk, eq_slots, Trash, inv_base, BeltSlot1, BeltSlot2, BeltSlot3, BeltSlot4, ShopStore_grid, ShopStore_base] #BeltSlot5]
	for c in containers:
		if c.get_global_rect().has_point(cursor_pos):
			return c
	return null

func drop_item(): 
	print('drop_item')
	Aeternus.return_item_to_the_ground(item_held)
	#print('item eliminado -> ' , item_held)
	# Podría poner una advertencia antes de accionar ... 
	item_held.queue_free()
	item_held = null
	to_drop = false

func return_item():
	item_held.global_position = last_pos
	last_container.insert_item(item_held)
	item_held = null

func pickup_item(item_id, pack = null):
	print('pickup_item -> ', item_id)
	var Pack = BackPack.Back_Pack if pack == null else pack
	var item = item_base.instantiate()
	item.set_meta("id", item_id)
	item.texture = load(Pack[item_id]['icon_inventary']) 
	item.name = item_id #BackPack.get_item(item_id)["name"]
	item.set_meta('stackable', Pack[item_id]['stackable'])
	if Pack[item_id]['stackable'] :
		item.set_meta('stack', 1)
		var label = Label.new()
		label.position = Vector2(4,2)
		label.set_text('')
		item.add_child(label)
	item.set_meta('name', item_id)
	if !is_reload :
		print('hasta aqui')
		print(Pack[item_id])
		add_child(item)
		BackPack.INVENTORY_UPDATED = false
		#var Grid = 'grid_bkpk' if pack == null else 'ShopStore_grid'
		if pack == null :
			if !grid_bkpk.insert_item_at_first_available_spot(item, is_reload):
				#if ![Grid].insert_item_at_first_available_spot(item, is_reload):
				#print('NO HAY MAS ESPACIO DISPONIBLE!!!!!')
				Aeternus.return_item_to_the_ground(item)
				item.queue_free()
				return false
		else :
			if !ShopStore_grid.insert_item_at_first_available_spot(item, is_reload):
				#if ![Grid].insert_item_at_first_available_spot(item, is_reload):
				#print('NO HAY MAS ESPACIO DISPONIBLE!!!!!')
				Aeternus.return_item_to_the_ground(item)
				item.queue_free()
				return false
			
	return true

func belt_offset_on(this):		
	this.set_offset(1, Belt_offset)
	this.set_offset(3, Belt_offset + 45)

func belt_offset_off(this):		
	this.set_offset(1, Belt_offset - 217)
	#this.set_offset(3, Belt_offset - 628)

func _on_inventory_button_pressed():
	inventory_on = !inventory_on
	#if !inventory_on :
		#inventory_on = true
	#elif inventory_on :
		#inventory_on = false

func _on_stats_button_pressed():
	print('STATS')

func _on_close_btn_texture_button_up():
	inventory_on = false

func insert_item_in_belt():
	pass

func transaction(mouvement) :
	var buying_price
	var selling_price
	print(item_held)
	#var Store = ShopStore_grid.items_store
	print('ShopStore_grid -> ')
	if mouvement == 'buy' :
		print('BUYING')
		print('to buy -> ', ShopStore_grid.ShopStore[item_held.name])
		
		print('price to buy -> ',ShopStore_grid.ShopStore[item_held.name].buying_price )
		print('Hero treasure -> ', BackPack.Treasure['Coins'])
		
		if BackPack.Treasure['Coins'] >= ShopStore_grid.ShopStore[item_held.name].buying_price :
			print('YOU CAN AFFORD IT ')
			BackPack.Treasure['Coins'] -= ShopStore_grid.ShopStore[item_held.name].buying_price
		else :
			print('NOT ENOUGH MONEY')
			return false
		
		BackPack.Back_Pack[item_held.name] = ShopStore_grid.ShopStore[item_held.name]
		ShopStore_grid.ShopStore.erase(item_held.name) 
		
	elif mouvement == 'sell' :
		print('SELLING')
		print('to sell -> ', BackPack.Back_Pack[item_held.name])
		print('price to sell  -> ',  BackPack.Back_Pack[item_held.name].selling_price )
		print('Hero treasure -> ', BackPack.Treasure['Coins'])
		
		BackPack.Treasure['Coins'] += BackPack.Back_Pack[item_held.name].selling_price
		
		print('NEW Hero treasure value -> ', BackPack.Treasure['Coins'])
		
		ShopStore_grid.ShopStore[item_held.name] = BackPack.Back_Pack[item_held.name]
		BackPack.Back_Pack.erase(item_held.name)
		#return true
	#print('TRANSACTION')
