extends Node

class_name File


var default_save_file = "user://save_game_json.json"
var save_file_path = default_save_file #"user://save_game.dat"
#var save_filename = "PlayerSave.tres"
#var inventory_path = "res://Scenes/UI/inventory_.tscn"

var save_game_FILE = JSON.new()
var save_game_info_FILE = JSON.new()

#var save_file_path = default_save_file

var data = {}

var save_stage_info

var Level = 'hero_data.Level24'
var INVENTORY

var saves_info = []
var saves_info_1 = {
	'path' : 'user://info_save_file_1.json',
	'file_name' : 'save_file_1',
	'stage_name' : null,
	'hero_name' : '',
	'hero_level' : '',
}
var saves_info_2 = {
	'path' : 'user://info_save_file_2.json',
	'file_name' : 'save_file_2',
	'stage_name' : null,
	'hero_name' : '',
	'hero_level' : '',
}
var saves_info_3 = {
	'path' : 'user://info_save_file_3.json',
	'file_name' : 'save_file_3',
	'stage_name' : null,
	'hero_name' : '',
	'hero_level' : '',
}


var saves_buttons = [] # [saves_info_1, saves_info_2, saves_info_3]
var load_buttons = []
var load_welcome = []

func _ready():
	print('READY Save')
	saves_info.append(saves_info_1)
	saves_info.append(saves_info_2)
	saves_info.append(saves_info_3)
	load_game_info()
	

func refresh_buttons():
	print('func refresh_buttons():')
	for gi in saves_info.size() :
		var i = gi - 1
		if saves_info[i]['stage_name'] != null :
			if !saves_buttons.is_empty():
				saves_buttons[i].text = saves_info[i]['hero_name'] + ' : ' + StagesDB.Stages[saves_info[i]['stage_name']]['name']
				load_buttons[i].text = saves_info[i]['hero_name'] + ' : ' + StagesDB.Stages[saves_info[i]['stage_name']]['name']
				load_buttons[i].disabled = false #saves_info[gi]['stage_name']
		if !load_welcome.is_empty() :
			if is_instance_valid(load_welcome[gi]):
				if saves_info[i]['stage_name'] != null :
					load_welcome[i].disabled = false
					load_welcome[i].text = StagesDB.Stages[saves_info[i]['stage_name']]['name']
				else :
					load_welcome[i].disabled = true


func save_game(Save_Stage):  # Inventory, Equiped
	## Archivo JSON
	save_file_path = "user://" + Save_Stage + ".json" if Save_Stage != null else default_save_file

	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if save_file :
		save_file.store_string(save_game_FILE.stringify(save_dictionary(Save_Stage)))
		save_file.close()
		print("Archivo creado y escrito correctamente.")
		save_file = null
		#refresh_buttons()
		save_game_info(Save_Stage) 
	else:
		print("Error al abrir el archivo: ", save_file)
		

func save_game_info(game):
	print('save_game_info')
	if save_stage_info != null and !save_stage_info.empty():
		for si in saves_info : # itera la variable
			if si['file_name'] == game : # la compara con la información recibida
				var save_info = FileAccess.open(si['path'], FileAccess.WRITE)
				if save_info :
					save_info.store_string(save_game_info_FILE.stringify(save_stage_info))
					#print(save_info)
					save_info.close()
					print("Archivo SAVE GAME INFO creado y escrito correctamente.")
					save_info = null
					# remplazar el archivo que se encuentra en saves_info por el actual
					replace_info_game(game, save_stage_info)
				else :
					print("Error al crear el archivo: ", saves_info)
	else :
		print('save_stage_info is empty')				

func replace_info_game(game, stage_info):
	print('replace_info_game')
	var index
	for games in saves_info	:
		if games['file_name'] == game :
			index = saves_info.find(games)
	if index > -1 :
		saves_info[index] = stage_info
	refresh_buttons()


func load_game(Load_Stage):
	print('Load game -> ', Load_Stage )
	var load_file_path = "user://" + Load_Stage + ".json" if Load_Stage != null else default_save_file
	var load_file = FileAccess.open(load_file_path, FileAccess.READ)
	if load_file :
		var load_data = save_game_FILE.parse_string(load_file.get_as_text())
		load_game_data(load_data) 
		load_file.close()
		load_file = null 
		refresh_buttons()
		print('dataloaded')
	else:
		print("Error al cargar el archivo: ", load_file)

func load_game_info():
	print('load_info')
	for gi in saves_info :
		if FileAccess.file_exists(gi['path']) :
			var load_info =  FileAccess.open(gi['path'], FileAccess.READ)
			if load_info :
				var load_data_info = save_game_info_FILE.parse_string(load_info.get_as_text())
				gi['stage_name'] = load_data_info['stage_name']
				gi['hero_name'] = load_data_info['hero_name']
				gi['hero_level'] = load_data_info['hero_level']
				load_info.close() 
				load_data_info = null
				refresh_buttons()
			else:
				print("Error al abrir el archivo: ", gi['path'])
		else:
			print("Archivo no encontrado: ", gi['path'])			


func load_game_data(data):
	print('load_game_data')
	## ------- Stage info  ------- ##
	Aeternus.clear_inventory()
	hero_data.reset_stats()
	
	Aeternus.Current_stage = data['Current_stage']  ## Name or ID 
	Aeternus.CURRENT_SCENE = data['CURRENT_SCENE']
	Aeternus.Stage_level = data['Stage_level']  ## Dificulty level
	
	## ------- Hero data & infos ------- ##
	
	hero_data.hero_name = data['hero_name']
	hero_data.PROGRESS = data['progression']
	hero_data.NOTE_BOOK = data['notebook']
	hero_data.FOLLOWERS = data['followers']
	
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
	#print('------------ cinturon ------------')
	#print(data['BackPack_cinturon'] )
	BackPack.Important_Items = data['BackPack_Important_Items']  
	#BackPack.new_item = data['BackPack_new_item']  
	BackPack.Treasure = data['BackPack_Treasure'] 

	equiped.items = data['Equiped_items'] 
	
	## Atención aquí, tratar los items "ESPECIALES" de manera distinta al cargalos.
	## Por ejemplo, llaves que solo pertenecen a una escena y no pueden existir dos veces,
	## tienen que desaparecer del inventario al cargarlos nuevamente. 
	## sólo después de eso debe volver a carga la escena. 
	equiped.load_equiped_slots()
	
	### Aqui trabajar los elementos equipados antes de crear una nueva instancia 		
	#Aeternus.change_Scene(data['Current_stage'].get_slice(":", 0), false)
	print('casi fin de load game en SAVE')
	Aeternus.change_Scene(data['Current_stage'], null, false)
	print('fuera de Aeternus.change_Scene(data[Current_stage], false)')
	
	
#func create_new_save_file():
	#var file = FileAccess.open("res://Scripts/default_save_file.json", FileAccess.READ)
	#var content = save_game_FILE.parse_string(file.get_as_text())
	#data = content
	##save_game(content)
		
func save_dictionary(game)	: # Equiped
	var Save_DIC = {}
	
	## ------- Hero data & infos ------- ##
	
	Save_DIC['hero_name'] = hero_data.hero_name
	Save_DIC['progression'] = hero_data.PROGRESS 
	Save_DIC['notebook'] = hero_data.NOTE_BOOK
	Save_DIC['followers'] = hero_data.FOLLOWERS 
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
	
	#print('Saved Hero info and Stats in Save_DIC')
	
	## ------- Back Pack & Items  ------- ##
	
	Save_DIC['BackPack_Back_Pack']  = BackPack.Back_Pack
	Save_DIC['BackPack_cinturon']  = BackPack.cinturon
	Save_DIC['BackPack_Important_Items']  = BackPack.Important_Items
	#Save_DIC['BackPack_new_item']  = BackPack.new_item
	Save_DIC['BackPack_Treasure'] = BackPack.Treasure
	Save_DIC['Equiped_items'] = equiped.items
	
	#print('Saved Equipment and treasure in Save_DIC')
	
	## ------- Stage info  ------- ##
	
	Save_DIC['Current_stage'] = Aeternus.Current_stage ## Name or ID 
	Save_DIC['CURRENT_SCENE'] = Aeternus.CURRENT_SCENE 
	Save_DIC['Stage_level'] = Aeternus.Stage_level ## Dificulty level
	
	#print('Saved Stage info in Save_DIC')
	save_stage_info = {
		'stage_name' : Save_DIC['Current_stage'],
		'hero_name' : hero_data.hero_name, #Aeternus.HERO.NAME,
		'hero_level' : Save_DIC['hero_data_Level'],
		'missions'	: Save_DIC['missions'],
		'notebook' : Save_DIC['notebook'],
	}
	#print('HERO NAME -> ', Aeternus.HERO.NAME)
	#save_game_info(game,Save_DIC['Current_stage'],Aeternus.HERO.NAME,Save_DIC['hero_data_Level'])
	
	return Save_DIC
	
