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
#@onready var BeltSlot5 = $BeltSlot_5
@onready var Trash = $Trash

@onready var Item_info = $Item_Info

var item_held = null
var item_offset = Vector2()
var last_container = null
var last_pos =Vector2()

var inventory_on = false
var to_drop = false
var is_reload = false

#var grid_x
#var grid_y

var offset_up
var Belt_offset

func _ready():	
	offset_up = get_offset(1)
	Belt_offset = BeltSlot1.get_offset(1)
	get_items_in_BackPack()

func get_items_in_BackPack() :
	print('inventory_.gd : 40 // ', 'get_items_in_BackPack' )
	is_reload = true
	for Items in BackPack.Back_Pack:
		print(Items)
		pickup_item(Items)
	is_reload = false	

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

	if BackPack.INVENTORY_UPDATED :
		#print(' .............. INVENTORY_UPDATED  --- Inventory')
		var new_item_id = BackPack.new_item.unique_id #if BackPack.new_item.itemClass != 'potion' else BackPack.new_item.name
		pickup_item(new_item_id)
		#pickup_item(BackPack.new_item)
	
func grab(cursor_pos):
	#print('grab - inventory')
	var c = get_container_under_cursor(cursor_pos)
	if c != null and c.has_method("grab_item"):
		item_held = c.grab_item(cursor_pos)
		if item_held != null:
			for iin in c.items:
				if c.name.find("BeltSlot") > -1 && str(iin).find(str(item_held.name)) > -1 :
					c.items.erase(c.items.keys()[1])
			last_container = c
			last_pos = item_held.global_position
			item_offset = item_held.global_position - cursor_pos
			if to_drop:
				drop_item()
			else :
				if item_held.get_parent().name != "Inventory_" :
					print(item_held.get_parent().name)
				else :	
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
	var it = get_container_under_cursor(pos)
	if it != null and it.has_method("grab_item"):
		var stack
		var label
		if BackPack.INVENTORY_IS_VISIBLE && it.name.find("BeltSlot") <= -1:
			for the in grid_bkpk.items:
				if the.get_global_rect().has_point(pos):
					if str(the.get_meta('name')).to_upper().find('POTION') > -1 :
						hero_data.drink_potion(the.get_meta('id'))
						if the.has_meta('stack') :
							stack = int(the.get_meta('stack')) 
						else:
							stack =  1
						stack -= 1
						if stack <= 0:
							to_drop = true
							grab(pos)
							return
						else :
							stack = str("") if stack == 1 else stack
							the.set_meta("stack", stack)
							the.get_children()[0].set_text(str(stack))
							return
					else:
						return false				
		if it.name.find("BeltSlot") > -1:
			### In the BeltSlot
			#print(it.items)
			for pot in it.items:
				#print(pot.to_upper())
				if str(pot).to_upper().find('POTION') > -1 :
					#print(('found'))
					#print(BackPack.Back_Pack)
					#print(pot.substr(pot.find('_x_') + 3))
					#print(pot.get_meta('name_id'))
					#print(BackPack.Back_Pack[pot.substr(pot.find('_x_') + 3)])
					var the_item = BackPack.Back_Pack[pot.substr(pot.find('_x_') + 3)]
					var subsStack = pot.get_slice('_s_', 1)
					var theStack = subsStack.get_slice('_x_',0)
					var theLabel = it.get_child(1).get_children()
					#print(the_item)
					#print('the_item')
					#print(the_item)
					the_item.stack = int(theStack)
					#print('donde se cae ???')
					#print(the_item.unique_id)
					hero_data.drink_potion(the_item.unique_id)
					stack =  1 if theLabel[0].get_text() == '' else int(theLabel[0].get_text())	  # pot.stack if !lab.is_empty() else 1
					label = theLabel[0]
					stack -= 1
					if stack > 0 :
						the_item.stack = stack
						stack = "" if stack == 1 else str(stack)
						label.set_text(stack)
						return
					elif stack <= 0:
						to_drop = true
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
	elif c.has_method("insert_item"):
		if c.insert_item(item_held):
			item_held = null
		else:
			return_item()
	else:
		return_item()

func get_container_under_cursor(cursor_pos):
	var containers = [grid_bkpk, eq_slots, Trash, inv_base, BeltSlot1, BeltSlot2, BeltSlot3, BeltSlot4] #BeltSlot5]
	for c in containers:
		if c.get_global_rect().has_point(cursor_pos):
			return c
	return null
	

func drop_item(): 
	print('item eliminado -> ' , item_held)
	# Podría poner una advertencia antes de accionar ... 
	item_held.queue_free()
	item_held = null
	to_drop = false

func return_item():
	item_held.global_position = last_pos
	last_container.insert_item(item_held)
	item_held = null
 
func pickup_item(item_id):
	print('inventory_.gd : 235 -> pickup item : item_id : ' + item_id)
	var item = item_base.instantiate()
	item.set_meta("id", item_id)
	item.texture = load(BackPack.Back_Pack[item_id]['icon_inventary']) 
	item.name = item_id #BackPack.get_item(item_id)["name"]
	item.set_meta('stackable', BackPack.Back_Pack[item_id]['stackable'])
	item.set_meta('name', item_id)
	if !is_reload :
		print('no es reload')
		add_child(item)
		#print(is_reload)
		BackPack.INVENTORY_UPDATED = false
		if !grid_bkpk.insert_item_at_first_available_spot(item, is_reload):
			print('NO HAY MAS ESPACIO DISPONIBLE!!!!!')
			item.queue_free()
			return false
	# print('jumped !grid_bkpk')	
	return true

func belt_offset_on(this):		
	this.set_offset(1, Belt_offset)
	this.set_offset(3, Belt_offset + 45)

func belt_offset_off(this):		
	this.set_offset(1, Belt_offset - 217)
	#this.set_offset(3, Belt_offset - 628)

func _on_inventory_button_pressed():
	if !inventory_on :
		inventory_on = true
	elif inventory_on :
		inventory_on = false

func _on_stats_button_pressed():
	print('STATS')

func _on_close_btn_texture_button_up():
	inventory_on = false
