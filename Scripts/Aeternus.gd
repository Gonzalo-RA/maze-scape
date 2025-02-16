extends Node

#@onready var Hero_Data = preload('res://Scripts/Hero_data.gd')

var IS_GAME_PAUSED = true
var IS_WELCOME_SCREEN = true

var MAIN_TREE

var Inventory

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


var rng = RandomNumberGenerator.new()

## Data variable ###
var save_file_path = "user://save_game_json.json"


func _ready():
	randomize()
	#Hero_Data = preload('res://Scripts/Hero_data.gd')

func get_HERO(Hero):
	if Hero == null:
		return HERO
	else :
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
	
func get_camera(cam):
	CAMERA = cam

func current_stage():
	return Current_stage

func stage_level():
	return Stage_level
		
func new_game():
	pass

func refresh_hero():
	HERO.queue_free()
	var new_hero = HERO.instantiate()
	MAIN_TREE.add_child(new_hero)
	HERO = new_hero

func return_item_to_the_ground(the_item ):
	var rd_value = RandomNumberGenerator.new()
	var the_thing = returned_item.instantiate()
	var item_name
	if typeof(the_item) == TYPE_OBJECT :
		item_name = the_item.name
	elif typeof(the_item) == TYPE_STRING :	
		item_name = Aeternus.EQUIPED[the_item].name
	the_thing.Data = BackPack.Back_Pack[item_name] 
	the_thing.position =  HERO.position 
	the_thing.position.x = HERO.position.x + randf_range(-10, 10) 
	the_thing.position.y = HERO.position.y + randf_range(-10, 10) 
	call_deferred('add_to_scene', the_thing)

func add_to_scene(the_thing):
	CURRENT_SCENE.add_child(the_thing)

func  clear_inventory():
	GUI.queue_free()
	var new_gui_load = load("res://Scenes/UI/gui.tscn")
	var new_gui = new_gui_load.instantiate()
	await get_tree().create_timer(1).timeout
	MAIN_TREE.add_child(new_gui)
	GUI = new_gui

func change_Scene(next_stage_name, new):
	var New_scene_path = 'res://Scenes/Levels/' + next_stage_name + '.tscn'
	var New_Scene = load(New_scene_path) ## elemento a cargar
	var New_Stage = StagesDB.Stages[next_stage_name] ## diccionario con informacione
	var MAIN_TREE_children = MAIN_TREE.get_children().duplicate()

	for child in MAIN_TREE_children  :
		if child.name == 'Welcome_window':
			Welcome_window = child
		if child.name == 'Ground':
			child.queue_free()
		elif child.is_class("TileMap") :
			if child.name == Current_stage or child.name == 'Map':
				child.queue_free()
		if child.is_class('Node2D') :
			if child.name.contains('Stage_') or child.name.contains('World_Map') : 
				child.queue_free()	
	
	# Esperar un frame para que se procesen las llamadas a queue_free()
	await get_tree().create_timer(0.01).timeout # Un pequeño retraso es suficiente
	var The_New_Scene= New_Scene.instantiate()
	call_deferred('new_scene_add_child', The_New_Scene)

# Función que se ejecutará DEFERRED
func new_scene_add_child(curr_scene):
	
	MAIN_TREE.add_child(curr_scene)
	Current_stage = curr_scene.name
	var Current_scene_children = curr_scene.get_children()
	CAMERA.get_map()
	for child in Current_scene_children:
		if child.name == 'Start_Area' :
			HERO.position = child.position 
			hero_data.start_position = child.position
	await get_tree().create_timer(1).timeout
	if IS_GAME_PAUSED :
		GUI.pause_game()
	if Welcome_window != null :
		Welcome_window.queue_free()
		Welcome_window = null

func percent_trough(percent):
	return true if (rng.randi() % 100) <= percent else false 
	
func dice_through(num_of_dices, dice):
	#var rng = RandomNumberGenerator.new()
	var sum_of_through = 0
	var num_of_througs = 0
	while num_of_througs < num_of_dices:
		var through = rng.randi_range(1, dice)
		sum_of_through += through
		num_of_througs += 1 
	return sum_of_through

func Roll20():
	#var rng = RandomNumberGenerator.new()
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
		#print('NO SE ACTUALIZA ')
		#print('attacker.Damage_dices[0] -> ', attacker.Damage_dices[0])
		#print('attacker.Damage_dices[1] -> ', attacker.Damage_dices[1])
		#print('attacker.Damage_bonus -> ', attacker.Damage_bonus  )
		#print('att_attack -> ', att_attack)
		#print('Damage -> ', damage)
		#print(defender.block_absortion)
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

#func random_pick_from_list(name):
	#var List = name + '_name_list'
	#var name_list = name + '_DB'
	#var pick_from_list = Items_DB[List][rng.randi( ) % Items_DB[List].size()]
	##print(pick_from_list)
	##var type = Items_DB[name_list][pick_from_list].type
	#return pick_from_list

func get_icon_from_list(list, type):
	return Items_DB[list][type].icon
	
func get_slot_from_list(list, type):
	return Items_DB[list][type].slot
func get_and_pass(element) :
	return element
	
