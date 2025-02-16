extends Node

class_name File

var save_file_path = "user://save_game.dat"
var save_filename = "PlayerSave.tres"
var inventory_path = "res://Scenes/UI/inventory_.tscn"

var save_game_FILE = JSON.new()
var save_file_path_JSON = Aeternus.save_file_path # "user://save_game_json.json"

var data = {}

var Level = 'hero_data.Level24'
var INVENTORY

func _ready():
	pass

func save_game():  # Inventory, Equiped
	## Archivo JSON
	var save_file = FileAccess.open(save_file_path_JSON, FileAccess.WRITE)
	if save_file :
		save_file.store_string(save_game_FILE.stringify(save_dictionary()))
		save_file.close()
		print("Archivo creado y escrito correctamente.")
		save_file = null
	else:
		print("Error al abrir el archivo: ", save_file)

func load_game():

	var load_file = FileAccess.open(save_file_path_JSON, FileAccess.READ)
	if load_file :
		var load_data = save_game_FILE.parse_string(load_file.get_as_text())
		load_game_data(load_data)
		print('dataloaded')
	else:
		print("Error al cargar el archivo: ", load_file)


func load_game_data(data):
		## ------- Stage info  ------- ##
	Aeternus.clear_inventory()

	Aeternus.Current_stage = data['Current_stage']  ## Name or ID 
	Aeternus.CURRENT_SCENE = data['CURRENT_SCENE']
	Aeternus.Stage_level = data['Stage_level']  ## Dificulty level
	
	## ------- Hero data & infos ------- ##
	
	hero_data.start_position = data['start_position']
	
	hero_data.Level = data['hero_data_Level'] 
	hero_data.XP = data['hero_data_XP'] 
	hero_data.Points_to_distribute = data['hero_data_Points_to_distribute'] 
	hero_data.TO_LEVEL_UP = data['hero_data_TO_LEVEL_UP'] 
	
	hero_data.Strength = data['hero_data_Strength'] 
	hero_data.Constitution = data['hero_data_Constitution'] 
	hero_data.Dexterity = data['hero_data_Dexterity'] 
	hero_data.Intelligence = data['hero_data_Intelligence'] 
	hero_data.Wisdom = data['hero_data_Wisdom'] 
	hero_data.Charisma = data['hero_data_Charisma'] 
	
	hero_data.Weapons = data['hero_data_Weapons']
	
	hero_data.chart_of_equipment_modificators = data['hero_data_chart_of_equipment_modificators']
	hero_data.Ported_armor = data['hero_data_Ported_armor']
	
	hero_data.Ported_Armor = data['hero_data_Ported_Armor']
	hero_data.current_energy = data['hero_data_current_energy']
	 #hero_data.Sprint_energy = #data['hero_data_Sprint_energy'] 
	
	hero_data.Weapon = data['hero_data_Weapon']
	hero_data.equiped_weapon = data['hero_data_equiped_weapon']
	hero_data.equiped_armor = data['hero_data_equiped_armor']

	hero_data.base_health = data['hero_data_base_health'] 
	hero_data.Health = data['hero_data_Health'] 
	hero_data.current_health = data['hero_data_current_health'] 

	hero_data.base_mana = data['hero_data_base_mana'] 
	hero_data.Mana = data['hero_data_Mana'] 
	hero_data.current_mana = data['hero_data_current_mana'] 

	hero_data.Speed = data['hero_data_Speed']
	hero_data.Current_speed = data['hero_data_Current_speed']
	hero_data.Charging_speed = data['hero_data_Charging_speed']

	hero_data.attack_distance = data['hero_data_attack_distance'] 

	hero_data.Initial_chance = data['hero_data_Initial_chance']

	hero_data.Equipment_Data = data['hero_data_Equipment_Data']
	hero_data.Equiped_Items = data['hero_data_Equiped_Items']
	
	## ------- Back Pack & Items  ------- ##

	equiped.delete_return_items()
	BackPack.Back_Pack = {}
	BackPack.Back_Pack = data['BackPack_Back_Pack'] 
	BackPack.INVENTORY_TO_RELOAD = true
	#BackPack.re_load_BACKPACK()
	 
	BackPack.cinturon = data['BackPack_cinturon']  
	BackPack.Important_Items = data['BackPack_Important_Items']  
	BackPack.new_item = data['BackPack_new_item']  
	BackPack.Treasure = data['BackPack_Treasure'] 

	equiped.items = data['Equiped_items'] 
	
	## Atención aquí, tratar los items "ESPECIALES" de manera distinta al cargalos.
	## Por ejemplo, llaves que solo pertenecen a una escena y no pueden existir dos veces,
	## tienen que desaparecer del inventario al cargarlos nuevamente. 
	## sólo después de eso debe volver a carga la escena. 
	equiped.load_equiped_slots()
	
	### Aqui trabajar los elementos equipados antes de crear una nueva instancia 		
	
	Aeternus.change_Scene(data['CURRENT_SCENE'].get_slice(":", 0), false)

	
	
	
#func create_new_save_file():
	#var file = FileAccess.open("res://Scripts/default_save_file.json", FileAccess.READ)
	#var content = save_game_FILE.parse_string(file.get_as_text())
	#data = content
	##save_game(content)
		
func save_dictionary()	: # Equiped
	var Save_DIC = {}
	
	## ------- Hero data & infos ------- ##
	
	Save_DIC['start_position'] = hero_data.start_position
	
	Save_DIC['hero_data_Level'] = hero_data.Level
	Save_DIC['hero_data_XP'] = hero_data.XP
	Save_DIC['hero_data_Points_to_distribute'] = hero_data.Points_to_distribute
	Save_DIC['hero_data_TO_LEVEL_UP'] = hero_data.TO_LEVEL_UP
#
	Save_DIC['hero_data_Strength'] = hero_data.Strength
	Save_DIC['hero_data_Constitution'] = hero_data.Constitution
	Save_DIC['hero_data_Dexterity'] = hero_data.Dexterity
	Save_DIC['hero_data_Intelligence'] = hero_data.Intelligence
	Save_DIC['hero_data_Wisdom'] = hero_data.Wisdom
	Save_DIC['hero_data_Charisma'] = hero_data.Charisma
	
	Save_DIC['hero_data_Weapons'] = hero_data.Weapons
	
	Save_DIC['hero_data_chart_of_equipment_modificators'] = hero_data.chart_of_equipment_modificators
	Save_DIC['hero_data_Ported_armor'] = hero_data.Ported_armor
	
	Save_DIC['hero_data_Ported_Armor'] = hero_data.Ported_Armor
	Save_DIC['hero_data_current_energy'] = hero_data.current_energy
	#Save_DIC['hero_data_Sprint_energy']  = hero_data.Sprint_energy
	
	Save_DIC['hero_data_Weapon'] = hero_data.Weapon
	Save_DIC['hero_data_equiped_weapon'] = hero_data.equiped_weapon
	Save_DIC['hero_data_equiped_armor'] = hero_data.equiped_armor

	Save_DIC['hero_data_base_health']  = hero_data.base_health
	Save_DIC['hero_data_Health']  = hero_data.Health
	Save_DIC['hero_data_current_health']  = hero_data.current_health

	Save_DIC['hero_data_base_mana']  = hero_data.base_mana
	Save_DIC['hero_data_Mana']  = hero_data.Mana
	Save_DIC['hero_data_current_mana']  = hero_data.current_mana

	Save_DIC['hero_data_Speed'] = hero_data.Speed
	Save_DIC['hero_data_Current_speed'] = hero_data.Current_speed
	Save_DIC['hero_data_Charging_speed'] = hero_data.Charging_speed

	Save_DIC['hero_data_attack_distance']  = hero_data.attack_distance

	Save_DIC['hero_data_Initial_chance'] = hero_data.Initial_chance

	Save_DIC['hero_data_Equipment_Data'] = hero_data.Equipment_Data
	Save_DIC['hero_data_Equiped_Items'] = hero_data.Equiped_Items
	
	print('Saved Hero info and Stats in Save_DIC')
	
	## ------- Back Pack & Items  ------- ##
	
	Save_DIC['BackPack_Back_Pack']  = BackPack.Back_Pack
	Save_DIC['BackPack_cinturon']  = BackPack.cinturon
	Save_DIC['BackPack_Important_Items']  = BackPack.Important_Items
	Save_DIC['BackPack_new_item']  = BackPack.new_item
	Save_DIC['BackPack_Treasure'] = BackPack.Treasure
	Save_DIC['Equiped_items'] = equiped.items
	
	print('Saved Equipment and treasure in Save_DIC')
	
	## ------- Stage info  ------- ##
	
	Save_DIC['Current_stage'] = Aeternus.Current_stage ## Name or ID 
	Save_DIC['CURRENT_SCENE'] = Aeternus.CURRENT_SCENE 
	Save_DIC['Stage_level'] = Aeternus.Stage_level ## Dificulty level
	
	print('Saved Stage info in Save_DIC')
	
	return Save_DIC
	
