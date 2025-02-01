extends Node

#@onready var Hero_Data = preload('res://Scripts/Hero_data.gd')
var Current_stage = 1 # Name or ID 
var Stage_level = 1 # Dificulty level

var Hero_Data
var HERO
var HERO_Level 
var HERO_XP 
var ESCENE_ITEMS = {}

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



func _ready():
	randomize()
	#Hero_Data = preload('res://Scripts/Hero_data.gd')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_HERO(Hero):
	if Hero == null:
		return HERO
	else :	
		HERO = Hero
		HERO_Level = Hero.Level
		HERO_XP = Hero.XP

func current_stage():
	return Current_stage

func stage_level():
	return Stage_level

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
		print('Failed attack')
		return false
	
#func remove_ported_item(item):
	#print('REMOVE ITEM (from Aeternus) -> ' , item)

#func Stack_Items(base_Item, hold_Item):
	#pass
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
#func generate_unique_ID(name):
	#var new_name = name + '_' + str( rng.randfn() ) 
	#new_name = new_name.replace('.','_')
	#return new_name.to_snake_case()
	
