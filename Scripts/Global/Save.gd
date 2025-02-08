extends Node


var save_file_path = "user://save_game.dat"
var save_filename = "PlayerSave.tres"

var Level = 'hero_data.Level24'
var INVENTORY

func _ready():
	pass # Replace with function body.

func save_game():  # Inventory, Equiped
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	#save_serialized(save_file, Equiped)
	save_dictionary() # Equiped


func save_dictionary()	: # Equiped
	var Save_DIC = {}
	var Hero_info_DIC = {}
	var Equipemnt_info_DIC = {}
	var Stage_info_DIC = {}
	
	## ------- Hero data & infos ------- ##
	Hero_info_DIC['hero_data_Level'] = hero_data.Level
	Hero_info_DIC['hero_data_XP'] = hero_data.XP
	Hero_info_DIC['hero_data_Points_to_distribute'] = hero_data.Points_to_distribute
	Hero_info_DIC['hero_data_TO_LEVEL_UP'] = hero_data.TO_LEVEL_UP
#
	Hero_info_DIC['hero_data_Strength'] = hero_data.Strength
	Hero_info_DIC['hero_data_Constitution'] = hero_data.Constitution
	Hero_info_DIC['hero_data_Dexterity'] = hero_data.Dexterity
	Hero_info_DIC['hero_data_Intelligence'] = hero_data.Intelligence
	Hero_info_DIC['hero_data_Wisdom'] = hero_data.Wisdom
	Hero_info_DIC['hero_data_Charisma'] = hero_data.Charisma
	
	Hero_info_DIC['hero_data_Weapons'] = hero_data.Weapons
	
	Hero_info_DIC['hero_data_chart_of_equipment_modificators'] = hero_data.chart_of_equipment_modificators
	Hero_info_DIC['hero_data_Ported_armor'] = hero_data.Ported_armor
	
	Hero_info_DIC['hero_data_Ported_Armor'] = hero_data.Ported_Armor
	Hero_info_DIC['hero_data_current_energy'] = hero_data.current_energy
	#Hero_info_DIC['hero_data_Sprint_energy']  = hero_data.Sprint_energy
	
	Hero_info_DIC['hero_data_Weapon'] = hero_data.Weapon
	Hero_info_DIC['hero_data_equiped_weapon'] = hero_data.equiped_weapon
	Hero_info_DIC['hero_data_equiped_armor'] = hero_data.equiped_armor

	Hero_info_DIC['hero_data_base_health']  = hero_data.base_health
	Hero_info_DIC['hero_data_Health']  = hero_data.Health
	Hero_info_DIC['hero_data_current_health']  = hero_data.current_health

	Hero_info_DIC['hero_data_base_mana']  = hero_data.base_mana
	Hero_info_DIC['hero_data_Mana']  = hero_data.Mana
	Hero_info_DIC['hero_data_current_mana']  = hero_data.current_mana

	Hero_info_DIC['hero_data_Speed'] = hero_data.Speed
	Hero_info_DIC['hero_data_Current_speed'] = hero_data.Current_speed
	Hero_info_DIC['hero_data_Charging_speed'] = hero_data.Charging_speed

	Hero_info_DIC['hero_data_attack_distance']  = hero_data.attack_distance

	Hero_info_DIC['hero_data_Initial_chance'] = hero_data.Initial_chance

	Hero_info_DIC['hero_data_Equipment_Data'] = hero_data.Equipment_Data
	Hero_info_DIC['hero_data_Equiped_Items'] = hero_data.Equiped_Items
		
	##### static var alive = true
	##### static var TO_UPDATE = false
	##### static var ANIM_EQUIPMENT_UPDATE = false
	
	print('Hero_info_DIC : ')
	print(Hero_info_DIC)
	
	
	## ------- Back Pack & Items  ------- ##
	
	Equipemnt_info_DIC['BackPack_Back_Pack']  = BackPack.Back_Pack
	Equipemnt_info_DIC['BackPack_cinturon']  = BackPack.cinturon
	Equipemnt_info_DIC['BackPack_Important_Items']  = BackPack.Important_Items
	Equipemnt_info_DIC['BackPack_new_item']  = BackPack.new_item
	Equipemnt_info_DIC['BackPack_Treasure'] = BackPack.Treasure
	Save_DIC['Equiped_items'] = equiped.items
	
	## Save Equiped no lo necesito realmente. Lo que debo cargar el El diccionario de Equiped items en Equiped
	## Tomar todos los datos de cada uno de los equipos ... Numbre, unique ID, textura, tipo, nivel .... SLOT.
	## al momento de volver a cargarlos, reconstituirlos y generar una nueva instancia de ellos. 
	## Esto lo pudo gacr a través de una función directa en Equiped. 
	## También puedo llegar a aellos a través de Back_Pack.BackPack... if "equiped" & "slot" != null -> ingresarlos ... 
	##
	
	print('Equipemnt_info_DIC : ')
	print(Equipemnt_info_DIC)
	
	## ------- Stage info  ------- ##
	
	Stage_info_DIC['Current_stage'] = Aeternus.Current_stage ## Name or ID 
	Stage_info_DIC['Stage_level'] = Aeternus.Stage_level ## Dificulty level
	
	print('Stage_info_DIC : ')
	print(Stage_info_DIC)
	

func load_data(Inventory, Equiped) :
	print('LOAD // Save.gd')
	if FileAccess.file_exists(save_file_path) :
		var load_file = FileAccess.open(save_file_path, FileAccess.READ)
		#hero_data.Level = load_file.get_var()
		hero_data.Level = load_file.get_var()
		hero_data.XP = load_file.get_var()
		hero_data.Points_to_distribute = load_file.get_var()
		hero_data.TO_LEVEL_UP = load_file.get_var()
		#
		hero_data.Strength = load_file.get_var()
		hero_data.Constitution = load_file.get_var()
		hero_data.Dexterity = load_file.get_var()
		hero_data.Intelligence = load_file.get_var()
		hero_data.Wisdom = load_file.get_var()
		hero_data.Charisma = load_file.get_var()

		hero_data.Weapons = load_file.get_var()

		hero_data.chart_of_equipment_modificators = load_file.get_var()
		hero_data.Ported_armor = load_file.get_var()

		hero_data.Ported_Armor = load_file.get_var()
		hero_data.current_energy = load_file.get_var()
		#hero_data.Sprint_energy  = load_file.get_var(

		hero_data.Weapon = load_file.get_var()
		hero_data.equiped_weapon = load_file.get_var()
		hero_data.equiped_armor = load_file.get_var()

		hero_data.base_health  = load_file.get_var()
		hero_data.Health  = load_file.get_var()
		hero_data.current_health  = load_file.get_var()

		hero_data.base_mana  = load_file.get_var()
		hero_data.Mana  = load_file.get_var()
		hero_data.current_mana  = load_file.get_var()

		hero_data.Speed = load_file.get_var()
		hero_data.Current_speed = load_file.get_var()
		hero_data.Charging_speed = load_file.get_var()

		hero_data.attack_distance  = load_file.get_var()

		hero_data.Initial_chance = load_file.get_var()

		hero_data.Equipment_Data = load_file.get_var()
		hero_data.Equiped_Items = load_file.get_var()
		
		hero_data.alive = true
		hero_data.TO_UPDATE = true
		hero_data.ANIM_EQUIPMENT_UPDATE = true

		BackPack.Back_Pack  = load_file.get_var()
		BackPack.cinturon  = load_file.get_var()
		BackPack.Important_Items  = load_file.get_var()
		BackPack.new_item  = load_file.get_var()
		BackPack.Treasure = load_file.get_var()
		
		print('INVENTORY EN LOAD // Save.gd') 
		#Equiped.items = load_file.get_var(true)
		#print(Equiped.items)
		#INVENTORY = load_file.get_var()
		#print(INVENTORY)
		#Inventory.get_items_in_BackPack()
		#print(BackPack.Back_Pack)
		#Equiped.insert_item_after_load()
		
		print('end LOAD // Save.gd' )
		
	#	varable1 = load_file.get_var()
	else :
		print('No Data ... // Save.gd')
		#varable1 = 0

#func save(content):
	#var file = FileAccess.open(path,FileAccess.WRITE)
	#file.store_string(content)
	#file = null
	#
#func load_game():
	#var file = FileAccess.open(path,FileAccess.READ)
	#var content = file.get_as_text()
	#return content
#
#func _ready():
	#save(data)
	#print(load_game())
	
	
#func save_serialized(save_file) : #, Equiped
	#save_file.store_var(hero_data.Level)
	#save_file.store_var(hero_data.XP)
	#save_file.store_var(hero_data.Points_to_distribute)
	#save_file.store_var(hero_data.TO_LEVEL_UP)
##
	#save_file.store_var(hero_data.Strength) 
	#save_file.store_var(hero_data.Constitution) 
	#save_file.store_var(hero_data.Dexterity) 
	#save_file.store_var(hero_data.Intelligence) 
	#save_file.store_var(hero_data.Wisdom) 
	#save_file.store_var(hero_data.Charisma)
	#
	#save_file.store_var(hero_data.Weapons)
	#
	#save_file.store_var(hero_data.chart_of_equipment_modificators)
	#save_file.store_var(hero_data.Ported_armor)
	#
	#save_file.store_var(hero_data.Ported_Armor)
	#save_file.store_var(hero_data.current_energy)
	##save_file.store_var(hero_data.Sprint_energy )
	#
	#save_file.store_var(hero_data.Weapon)
	#save_file.store_var(hero_data.equiped_weapon)
	#save_file.store_var(hero_data.equiped_armor)
#
	#save_file.store_var(hero_data.base_health )
	#save_file.store_var(hero_data.Health )
	#save_file.store_var(hero_data.current_health )
#
	#save_file.store_var(hero_data.base_mana )
	#save_file.store_var(hero_data.Mana )
	#save_file.store_var(hero_data.current_mana )
#
	#save_file.store_var(hero_data.Speed)
	#save_file.store_var(hero_data.Current_speed)
	#save_file.store_var(hero_data.Charging_speed)
#
	#save_file.store_var(hero_data.attack_distance )
#
	#save_file.store_var(hero_data.Initial_chance)
#
	#save_file.store_var(hero_data.Equiped_Items)  # This is the equiped small items
	#save_file.store_var(hero_data.Equipment_Data) # This is the dressed equipement
		#
	###### static var alive = true
	###### static var TO_UPDATE = false
	###### static var ANIM_EQUIPMENT_UPDATE = false
	#
	#save_file.store_var(BackPack.Back_Pack )
	#save_file.store_var(BackPack.cinturon )
	#save_file.store_var(BackPack.Important_Items )
	#save_file.store_var(BackPack.new_item )
	#save_file.store_var(BackPack.Treasure)
	#print(equiped.items)
	#save_file.store_var(equiped.items, true)
	#
	##save_file.store_var(Inventory)
	##Inventory.get_items_in_BackPack()
	#
	#print('SAVE // Save.gd')	
