extends Node

var IS_GAME_PAUSED = true
var IS_WELCOME_SCREEN = true
var IS_TALKING_SCENE = false
var IS_TALKING_IMPORTANT_SCENE = false
var PNJ_TALKING
var TALK_SCRIPT

var MAIN_TREE

var Inventory
var Merchant_Inventory

enum game_states {WELCOME_SCREEN, PAUSE_MENU, GAME_PLAYING, TRANSITION, SCENE_PLAYING}
##					0				1			2				3			4
var GAME_STATE = game_states.WELCOME_SCREEN

var Current_stage # Name or ID 
var Stage_level = 1 # Dificulty level
var CURRENT_SCENE # como elemento escena
var CAMERA
var GUI
var Welcome_window
#var New_Scene

var Hero_Data
var HERO
var HERO_Level 
var HERO_XP 
var ESCENE_ITEMS = {}

@onready var returned_item = preload('res://Scenes/map_items/returned_item.tscn')

var EQUIPED = { "WEAPON": null ,
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

var XP_LEVELS = {
	'1' : 0,
	'2'	: 300,
	'3' : 900,
	'4' : 2700,
	'5' : 6500,
	'6' : 1400,
	'7' : 23000,
	'8' : 34000,
	'9' : 48000,
	'10': 64000,
	'11' : 85000,
	'12' : 100000,
	'13' : 120000,
	'14' : 140000,
	'15' : 165000,
	'16' : 195000,
	'17' : 225000,
	'18' : 265000,
	'19' : 305000,
	'20' : 355000,
	'21' : 400000	
}

var CHARACTERISTICS = [ 'Strength', 'Constitution', 'Dexterity', 'Intelligence', 'Wisdom', 'Charisma', ]

var Oject_Names_DB = {
	'Sustantivo' : ['Eye', 'Star', 'Light', 'Heart', 'Axe', 'Cloud', 'Fog', 'Whisper', 'Fire', 'Leter', 'Home', 'Wind','Shadow', 
	'Thief', 'Bull', 'Fetish', 'Stone', 'Feather',],
	
	'Adjetivo' : ['Hard', 'Dark', 'Impious', 'Fast', 'Bloody', 'Hidden' , 'Unseen', 'Red', 'Green', 'Blue', 'Black', 'White', ]
	}
	
var Names_DB = {
	'Name' : ['Shalin' , 'Hozayo', 'Cohur', 'Hanahisol', 'Bistolin', 'Parzuhel', 'Mischul', 'Kaizel', 'the Mountain', 'the Sky', 'the Sea',
	'the Forest', 'the Stone', 'the Morning', 'the Darkness', 'Nalstrum', 'Cyry', 'Elea', 'Sairiri', 'the History', 'the Fire', 'the Wind',
	'the Pit', 'the Cave', ]	
}

var Colors_DB = [
	'yellow', 'black', 'white', 'brown', 'gray_light', 'gray_dark',
	'green_light', 'green_dark','blue_dark', 'blue_light','red_light', 'red_dark',
	'magenta_light', 'magenta_dark', 'cyan_light', 'cyan_dark'
]

var Shirt_DB = ['short', 'long', 'dress']
var Beart_DB = [null, 'babilonic', 'full', 'goatee', 'long', 'stap']
var Hair_DB = ['short', 'long_straight', 'thick', 'puffy', 'bald']

var PNJ_type_DB = ['country_person','slave','worker', 'city_person','courtier','militar','random' ]
var Race_DB = ['human', 'orc', 'dwarf', 'random']
var Gender_DB = ['male', 'female', 'other', 'random' ]
var Alignement_DB = ['neutral', 'good', 'evil']
var PNJ_behavour_DB = ['waiting', 'walking', 'folow after action']

var rng = RandomNumberGenerator.new()

## Data variable ###
#var save_file_path = "user://save_game_json.json"

#var Working = false

func _ready():
	randomize()
	#Hero_Data = preload('res://Scripts/Hero_data.gd')

#func _process(delta):
	#if Working:
		#print('IS NOW WORKING')

func get_HERO(Hero):
	#print('enter get HERO')
	#print(Hero)
	if Hero == null:
		return HERO
	else :
		#print('Got HERO ')
		HERO = Hero
		HERO_Level = Hero.Level
		HERO_XP = Hero.XP
		MAIN_TREE = Hero.get_parent()

func get_inventory(inventory):
	Inventory = inventory
	
func get_SCENE(Scene):
	if Scene == null :
		return CURRENT_SCENE
	else :
		CURRENT_SCENE = Scene
		Current_stage = Scene.name
		
func get_GUI(gui):
	GUI = gui
	#print('Got GUI')
	
func get_camera(cam):
	CAMERA = cam

func current_stage():
	return Current_stage

func stage_level():
	return Stage_level
		
func new_game():
	pass
	
func to_home_sceen():
	#print('to_home_sceen')
	#MAIN_TREE.get_node('Welcome_window').visible = true
	#var home = load('res://Scenes/UI/welcome_window.tscn')
	#Welcome_window = home.instantiate()
	#MAIN_TREE.add_child(Welcome_window)
	#var escena_actual = get_tree().current_scene.scene_file_path
	
	if get_tree() != null:
		
		#var My_root = get_tree().current_scene.scene_file_path
		#var the_scene = preload('res://Scenes/main_map.tscn')
		#print(My_root)  # res://Scenes/main_map.tscn ## esta es la escena principal
		get_tree().reload_current_scene() # the_scene
		GAME_STATE = game_states.WELCOME_SCREEN
		#print('pasoo')
	else:
		print("Error: get_tree() devolvió null.")
	

	#reset_data()
	hero_data.reset_stats()
	
	await get_tree().create_timer(0.1).timeout # Un pequeño tiempo es suficiente
	GUI.pause_game()
	#call_deferred('delete_scenes')

#func reset_data():
	#hero_data.reset_stats()
	
#func delete_scenes():
	#if MAIN_TREE.has_node('GUI'): 
		#MAIN_TREE.get_node('GUI').queue_free()	
	#
	#await get_tree().create_timer(0.01).timeout # Un pequeño tiempo es suficiente
	#call_deferred('reload')
	
#func reload():
	#var gui = load("res://Scenes/UI/gui.tscn").instantiate()
	#gui.set_name('GUI')
	#var Ww = MAIN_TREE.get_node('Welcome_window')
	#var index = MAIN_TREE.get_children().find(Ww) # get_child_count()
	#MAIN_TREE.add_child(gui, true)
	#if index != -1 :
		#var gui_index = MAIN_TREE.get_children().find(gui)
		#if gui_index != -1: # Check if GUI was found (should be)
			#MAIN_TREE.move_child(MAIN_TREE.get_node('GUI'), index - 1) # Insert after Welcome_window
	#else:
		#print("Welcome_window not found!")
	#
	#await get_tree().create_timer(0.01).timeout 
	#GUI.pause_game()
	
	
#func refresh_hero():
	#print('refresh HERO')
	#var hero_parent = HERO.get_parent()
	#var hero_position = hero_parent.get_children().find(HERO)
	##print(hero_parent.get_children())
	#hero_parent.get_child(hero_position).queue_free()
	##HERO.queue_free()
	#var hero_node = load('res://Scenes/hero.tscn')
	#var new_hero = hero_node.instantiate()
	#new_hero.name = 'Hero'
	#MAIN_TREE.add_child(new_hero, hero_position)
	#HERO = new_hero

func return_item_to_the_ground(the_item ):
	#print('return_item_to_the_ground')
	var rd_value = RandomNumberGenerator.new()
	var the_thing = returned_item.instantiate()
	var item_name
	if typeof(the_item) == TYPE_OBJECT :
		item_name = the_item.name
	elif typeof(the_item) == TYPE_STRING :	
		item_name = Aeternus.EQUIPED[the_item].name
	
	the_thing.Data = BackPack.Back_Pack[item_name] 
	#print(the_thing.Data)
	the_thing.position =  HERO.position 
	the_thing.position.x = HERO.position.x + randf_range(-10, 10) 
	the_thing.position.y = HERO.position.y + randf_range(-10, 10) 
	call_deferred('add_to_scene', the_thing)

func add_to_scene(the_thing):
	#print('add_to_scene')
	if is_instance_valid(CURRENT_SCENE) :
		CURRENT_SCENE.add_child(the_thing)
	#else :
		#print(get_parent().get_node('main_map').get_children())	

func  clear_inventory():
	#print('clearing inventory')
	GUI.queue_free()
	var new_gui_load = load("res://Scenes/UI/gui.tscn")
	var new_gui = new_gui_load.instantiate()
	await get_tree().create_timer(0.01).timeout
	MAIN_TREE.add_child(new_gui)
	GUI = new_gui
	#print('inventory cleaned')

func change_Scene(next_stage_name, arriving_area, new):
	print('change _ Scene')
	#print(next_stage_name)
	#print(Aeternus.CURRENT_SCENE)
	var New_scene_path = 'res://Scenes/Levels/' + next_stage_name + '.tscn'
	var New_Scene = load(New_scene_path) ## elemento a cargar
	
	var New_Stage = StagesDB.Stages[next_stage_name] ## diccionario con informacione
	
	var MAIN_TREE_children = MAIN_TREE.get_children().duplicate()
	HERO.get_parent().remove_child(HERO)
	
	for child in MAIN_TREE_children  :
		if child.name == 'Welcome_window':
			Welcome_window = child
		if child.name == 'Ground':
			child.queue_free()
		elif child.is_class("TileMap") :
			if child.name == Current_stage or child.name == 'Map':
				child.queue_free()
		if child.is_class('Node2D') :
			#print('is class Node2D')
			if child.name.contains('Stage_') or child.name.contains('World_Map') : 
				child.queue_free()
		if child.is_class('map_config'):
			#print('is class map_config')
			child.queue_free()
			
	await get_tree().create_timer(0.3).timeout # Un pequeño retraso es suficiente
	var The_New_Scene = New_Scene.instantiate()
	for map in The_New_Scene.get_children() :
		if map.is_class("TileMap"):
			map.add_child(HERO)
	call_deferred('new_scene_add_child', The_New_Scene, arriving_area)

func new_scene_add_child(curr_scene, arriving_area):
	#print('new_scene_add_child')
	MAIN_TREE.add_child(curr_scene)
	Current_stage = curr_scene.name
	var Current_scene_children = curr_scene.get_children()
	CAMERA.get_map()
	if arriving_area != null and arriving_area != '00' :
		var Arriving_Area = 'Arriving_Area_' + arriving_area
		HERO.position = curr_scene.get_node(Arriving_Area).position
	else :
		for child in Current_scene_children:
			if child.name == 'Start_Area' :
				HERO.position = child.position 
				hero_data.start_position = child.position
	await get_tree().create_timer(3).timeout
	#print('continuacion')
	if IS_GAME_PAUSED :
		GAME_STATE = game_states.PAUSE_MENU
		GUI.pause_game()
	if Welcome_window != null :
		GAME_STATE = game_states.WELCOME_SCREEN
	#print('END  - new_scene_add_child')
	
func percent_trough(percent):
	return true if (rng.randi() % 100) <= percent else false 
	
func dice_through(num_of_dices, dice):
	var sum_of_through = 0
	var num_of_througs = 0
	while num_of_througs < num_of_dices:
		var through = rng.randi_range(1, dice)
		sum_of_through += through
		num_of_througs += 1 
	return sum_of_through

func Roll20():
	var through = randi() % 21 + 1 # rng.randi_range(1, 20)
	if through == 20 :
		print('CRITIC !!!!')
	elif through == 1 :
		print('CRITIC FAILLLLLL !!!!')	
	return through

func match_Attack(attacker, defender):
	var through = Roll20()
	var att_attack = attacker.Attack
	var def = defender 
	if (through + att_attack ) >= def.Armor || through == 20 :
		var damage = dice_through(attacker.Damage_dices[0], attacker.Damage_dices[1]) + attacker.Damage_bonus
		if defender.blocking :
			damage =  damage - defender.block_absortion if damage - defender.block_absortion > 0 else 0
		#if through == 20 :
		damage = damage * 2 if through == 20 else damage
	
		defender.hit(damage)
		return true
	elif through + att_attack < def.Armor || through == 1:
		#print('Failed attack')
		return false
	
func Random_Pick_Name():
	return	Names_DB.Name[rng.randi() % Names_DB.Name.size()]

func Random_Pick_Adjetivo():
	return Oject_Names_DB.Adjetivo[rng.randi() % Oject_Names_DB.Adjetivo.size()]

func Random_Pick_Sustantivo():
	return Oject_Names_DB.Sustantivo[rng.randi() % Oject_Names_DB.Sustantivo.size()]

func random_Name_Generator(Item, rarity):
	var subject = Random_Pick_Adjetivo() + ' ' + Random_Pick_Sustantivo()  if rarity == 'rare' else Random_Pick_Adjetivo() + ' ' + Item.capitalize() # else Item.capitalize()
	var rarity_ = Random_Pick_Name() if rarity == 'legendary' or rarity == 'magic' else ''
	var The_Name = 'The ' + subject + ' of ' + rarity_ if rarity == 'legendary' or rarity == 'magic' else subject 
	return The_Name	if rarity != 'common' else Random_Pick_Adjetivo() + ' ' + Item.capitalize()

func iterate_dictionary_by_index(dictio, num):
	var index = 0
	for key in dictio :
		if num == index :
			return key
		index += 1

func get_icon_from_list(list, type):
	return Items_DB[list][type].icon
	
func get_slot_from_list(list, type):
	return Items_DB[list][type].slot
func get_and_pass(element) :
	return element

func give_item(item):
	#BackPack.Back_Pack
	print(item)
	BackPack.add_to_bag(item)

func give_info(info):
	print(info)

#### TALKING & MISSIONS #####

func active_dialogue_window(pnj, dialogue_script):
	print('active_dialogue_window')
	IS_TALKING_SCENE = true
	PNJ_TALKING = pnj
	pnj.Is_Talking = true
	pnj.talk()
	if !hero_data.PROGRESS.Missions.has(pnj.Mission_name) :
		hero_data.PROGRESS.Missions[pnj.Mission_name] = dialogue_script[pnj.Mission_name]
	GUI.Dialogue_Window.PNJ = pnj
	GUI.Dialogue_Window.Mission_Script = hero_data.PROGRESS.Missions[pnj.Mission_name]
	GUI.Dialogue_Window.change_reading_states(GUI.Dialogue_Window.read_state.READY)
	
func clean_follower(follower) :
	follower.following = false
	follower._on_interaction_area_body_exited(Aeternus.HERO)
	follower.current_state = follower.pnj_states.IDLE_FRONT
	follower.Response = 'waiting' 
	follower.resume_behaviour()
	follower.mission_cumplida = true
	
func end_dialog() :	
	IS_TALKING_IMPORTANT_SCENE = false
	IS_TALKING_SCENE = false
	PNJ_TALKING.HERO_is_CLOSE = false
	PNJ_TALKING.Is_Talking = false
	PNJ_TALKING = null
	
	
