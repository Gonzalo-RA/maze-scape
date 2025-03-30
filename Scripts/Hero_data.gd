extends Node
class_name hero_data 

# PRELOAD INFORMATIONS FROM A JSON FILE

# @onready var initial_equipment = preload() 
	# from the initial_equipment determine que current equipment 
	# gold, potions, gems, weapons, scrolls, etc.
# @onready var weapons_data = preload()  # this must to be all the data from a database. 

static var hero_name = 'Geronimus'
static var Portrait_path = "res://Assets/Images/Portraits/hero.png"
static var PROGRESS = {'Progress' : {}, 'Missions' : {}, } ## Progress : { here the mandatory progression },   Missions : {} ,
static var FOLLOWERS = {}
static var NOTE_BOOK = {} ## Key events and things to know
# DICTIONARY 
# this must to be moved in to a general data JSON file, together with the whole liste of items 
static var Weapons = {
	'Punch' : {
		'name' : 'Punch',
		'damage' : 10,
		'speed' : 6,
		'scope'	: 10,
		'dices' : [1,4],
		'attackBonus' : 0,
		'damageBonus' : 0,
		'attack_scope' : 10,
		'bonus' : 0,
		'magic'	: false,
		'durability' : 100,
		#'Damage_modificator' : 0,
	}
}

# STATS

static var chart_of_equipment_modificators = {
	'Strength' : 0,#Strength ,
	'Constitution' : 0,#Constitution ,
	'Dexterity' : 0,#Dexterity ,
	'Intelligence' : 0,#Intelligence ,
	'Wisdom' : 0,#Wisdom ,
	'Charisma' : 0,#Charisma ,
	'Chance' : 0,#chart_of_equipment_modificators['] #chance_bonus,
	'Attack' : 0,#Item_attack_bonus ,
	'Armor' : 0,#Item_armor_bonus ,
	'Health' : 0,
	'Speed' : 0,
	'Mana' : 0,
	'Energy' : 0,#Item_energy_bonus,
	'Damage' : 0,#Item_damage_bonus,
	'Absorption' : 0,
	}

static var Ported_armor = {
	"Natural Armor" : {
		'name' : "Natural Armor",
		'itemClass' : "armor",
		'stackable' : false,
		'stack' : 1,
		'type' : 'skyn_armor',
		'level' : 1,
		'rarity' : "banal",
		'icon' : [8,4],
		'icon_inventary' :  null , #ICON_PATH + "Weapons/morning_star_1.png",
		'animation' : null,
		'speed' : 1,
		'dices' : [0,0],
		'dice': 1,
		'dicesQuantity': 1,
		'bonus': null,
		'damage_type' : null,
		'attack_scope' : 'body', 
		'bonus_afect_to' : 'Armor',
		'state_afected' : null,
		'cooldown' : null ,
		'attackBonus': 0,
		'damageBonus' : 0,
		'defense': 0,
		'absorption' : 0,
		'defenseDice': 0,
		'defenseDicesQuantity': 0,
		'defenseBonus': 0,
		'afectedCharacteristics' : null,
		'bonusToCharacteristic' : null,
	},
}


# static var level = 1 # this info coming from a JSON file

static var size = 'medium' # medium, large, extra large, geant, small, extra small, diminute
static var speed = 20

# LOT & ITEMS

static var equiped_weapon = ['Punch',]
static var Weapon = Weapons[equiped_weapon[0]]
static var equiped_armor = ['Natural Armor',]
#hero_data.Weapons[hero_data.equiped_weapon[0]]Natural Armor['damage']

static var Equiped_Items = {}

static var TO_UPDATE = false
static var ANIM_EQUIPMENT_UPDATE = false
# Stats 

static var alive = true
static var state = "Normal" # Normal, Poisoned, trapped, Invulnerable
# var performing = "idle" # Running, Jumping, Charging //  attacking
# var moving = false
static var dead_position
static var start_position

static var Level = 1
static var Next_level = Level + 1
static var XP = 0
static var Points_to_distribute = 0
static var difference_btw_levels = 300
static var lives = 5
static var TO_LEVEL_UP = false 

static var Strength = 10
static var Constitution = 10
static var Dexterity = 10
static var Intelligence = 10
static var Wisdom = 10
static var Charisma = 10

# var Weapon = Items_DB.ITEMS_DB['Punch']
static var Embestida
static var Ported_Armor =  Ported_armor[equiped_armor[0]] #Items_DB.ITEMS_DB[equiped_armor[0]] #

# 10-11 +0 / 12-13 +1 / 14-15 +2 / 16-17 +3 / 18-19 +4 / 20-21 +5
# 8-9 -1 / 6-7 -2 / 4-5 -3 / 2-3 -4 / 1 -5

static var Strength_modificator = floor(( (chart_of_equipment_modificators['Strength'] + Strength) - 10) / 2)
static var Constitution_modificator =  floor(( (chart_of_equipment_modificators['Constitution'] + Constitution) - 10) / 2)
static var Dexterity_modificator =  floor(( (chart_of_equipment_modificators['Dexterity'] + Dexterity) - 10) / 2)
static var Intelligence_modificator =  floor(( (chart_of_equipment_modificators['Intelligence'] + Intelligence) - 10) / 2)
static var Wisdom_modificator =  floor(( (chart_of_equipment_modificators['Wisdom'] + Wisdom ) - 10) / 2)
static var Charisma_modificator =  floor(( (chart_of_equipment_modificators['Charisma'] + Charisma) - 10) / 2)

static var temporal_strength_modificator = 0

static var base_energy = 100
static var Item_energy_bonus = 0 
static var max_energy = base_energy + (Strength_modificator * 10) + (Constitution_modificator * 10) + Item_energy_bonus #(Dexterity_modificator * 10) 
static var Energy = max_energy  #Current Energy
static var regen_energy = 0.01 + (Constitution_modificator / 50)
static var bonus_energy = 0
static var current_energy = Energy

#var Sprint_energy = 100 + (Strength_modificator * 10) + (Constitution_modificator * 10) + (Dexterity_modificator * 10)

static var base_health = 20
static var max_health = base_health + Constitution_modificator + chart_of_equipment_modificators['Health'] #health_bonus
static var Health = max_health # Current Health
static var regen_health = 0.1 + (Constitution_modificator / 10)
static var bonus_health = 0

static var base_mana = 100 
static var max_mana = base_mana + Intelligence_modificator + chart_of_equipment_modificators['Mana'] #mana_bonus
static var Mana = max_mana 
static var current_mana = Mana
static var bonus_mana = 0

static var Speed = 20 + (Dexterity_modificator )
static var Current_speed = Speed
static var Charging_speed = Speed + (Strength_modificator )

static var Weapon_speed_modificator = Weapon.speed # Weapons[equiped_weapon[0]].speed # Items_DB.ITEMS_DB[equiped_weapon[0]].speed

static var Attack_speed = 9 + Dexterity_modificator + Weapon.speed   # Items_DB.ITEMS_DB[equiped_weapon[0]].speed
static var Attack_modifcicator = Dexterity_modificator + Strength_modificator + Weapon.attackBonus + chart_of_equipment_modificators['Attack'] #attack_bonus# Items_DB.ITEMS_DB[equiped_weapon[0]].attackBonus

static var Damage_modificator = temporal_strength_modificator + Strength_modificator +  Weapon.damageBonus + chart_of_equipment_modificators['Damage'] #damage_bonus ##Items_DB.ITEMS_DB[equiped_weapon[0]].damageBonus 
static var attack_distance =  Weapon.attack_scope # Items_DB.ITEMS_DB[equiped_weapon[0]].attack_scope

static var natural_armor = 10
static var ported_armor_defence = Ported_Armor.defense + Ported_Armor.defenseBonus + chart_of_equipment_modificators['Armor'] #armor_bonus
static var Armor_absorption = Ported_Armor.absorption + chart_of_equipment_modificators['Absorption']
static var temportal_armor_bonus = 0

# -------- COOL DOWN -------- #

static var armor_cooldown 
static var strength_cooldown


# -------- CHANCE -------- #

static var Initial_chance = 50
static var chance_temporal_bonus = 0
static var Chance = Initial_chance + Wisdom_modificator + chance_temporal_bonus + chart_of_equipment_modificators['Chance'] #chance_bonus

# --–––––----- FINAL -------------- #

static var Armor = natural_armor + ported_armor_defence + temportal_armor_bonus
static var Attack = Attack_modifcicator
static var current_health = max_health
static var block_absortion =  Armor + Armor_absorption + Strength_modificator
static var blocking = false

# ---------- Enemy -------- #

static var Enemy_in_attack_range = false 


# ------- Equipment ------- # 

static var Equipment_Data = {
	'HEAD' : null,
	'WEAPON' : null,
	'SHIELD' : null,
	'CHEST' : null,
	'BELT' : null,
	'FEET' : null,
	'GLOVES' : null,
}

#static var emptpy_poquets = true

func _ready():
	pass

static func update_stats() :
	
	Strength = Strength 
	Constitution = Constitution 
	Dexterity = Dexterity 
	Intelligence = Intelligence 
	Wisdom = Wisdom 
	Charisma = Charisma 
	
	Strength_modificator = floor(( (chart_of_equipment_modificators['Strength'] + Strength) - 10) / 2)
	Constitution_modificator =  floor(( (chart_of_equipment_modificators['Constitution'] + Constitution) - 10) / 2)
	Dexterity_modificator =  floor(( (chart_of_equipment_modificators['Dexterity'] + Dexterity) - 10) / 2)
	Intelligence_modificator =  floor(( (chart_of_equipment_modificators['Intelligence'] + Intelligence) - 10) / 2)
	Wisdom_modificator =  floor(( (chart_of_equipment_modificators['Wisdom'] + Wisdom ) - 10) / 2)
	Charisma_modificator =  floor(( (chart_of_equipment_modificators['Charisma'] + Charisma) - 10) / 2)
	
	temporal_strength_modificator = temporal_strength_modificator
	
	base_energy = base_energy
	Item_energy_bonus = Item_energy_bonus
	max_energy = base_energy + (Strength_modificator * 10) + (Constitution_modificator * 10) + Item_energy_bonus + chart_of_equipment_modificators['Energy'] # (Dexterity_modificator * 10)
	Energy = Energy if Energy <= max_energy else max_energy # max_energy  #Current Energy
	regen_energy = 0.01 + (Constitution_modificator / 50)
	bonus_energy = bonus_energy
	current_energy = current_energy if current_energy <= max_energy else max_energy 
	
	base_health = base_health
	max_health = base_health + Constitution_modificator +  chart_of_equipment_modificators['Health']
	Health = Health # max_health # Current Health
	regen_health = 0.1 + (Constitution_modificator / 10)
	bonus_health = bonus_health
	current_health = current_health if current_health <= max_health else max_health #max_health
	
	base_mana = base_mana 
	max_mana = base_mana + Intelligence_modificator + chart_of_equipment_modificators['Mana']
	Mana = Mana # max_mana
	current_mana = current_mana
	bonus_mana = bonus_mana

	Speed = 20 + (Dexterity_modificator )
	Current_speed = Current_speed + chart_of_equipment_modificators['Speed'] # Speed
	Charging_speed = Speed + (Strength_modificator )
	
	Weapon_speed_modificator = Weapon.speed
	Attack_speed = 9 + Dexterity_modificator + Weapon.speed 
	Attack_modifcicator = Dexterity_modificator + Strength_modificator + Weapon.attackBonus + chart_of_equipment_modificators['Attack']
	
	Damage_modificator = temporal_strength_modificator + Strength_modificator +  Weapon.damageBonus + chart_of_equipment_modificators['Damage']
	attack_distance =  Weapon.attack_scope

	natural_armor = natural_armor
	ported_armor_defence = Ported_Armor.defense + Ported_Armor.defenseBonus + chart_of_equipment_modificators['Armor']
	Armor_absorption = Ported_Armor.absorption + chart_of_equipment_modificators['Absorption']
	temportal_armor_bonus = temportal_armor_bonus
	
	Initial_chance = Initial_chance
	chance_temporal_bonus = chance_temporal_bonus 
	Chance = Initial_chance + Wisdom_modificator + chance_temporal_bonus + chart_of_equipment_modificators['Chance']
	Armor = natural_armor + ported_armor_defence + temportal_armor_bonus
	Attack = Attack_modifcicator
	
	block_absortion =  Armor_absorption + Strength_modificator
	
	TO_UPDATE = true
	#print('Stats Updated (hero_data)')

#static func update_weapon(updated_weapon, add):
	#print('update_weapon')
	##Weapon = Weapons[equiped_weapon[0]]
	##print(Weapons)
	#update_characteristics(updated_weapon, true)
	##for CH in updated_weapon.affectations :
		##chart_of_equipment_modificators[CH] = chart_of_equipment_modificators[CH] + updated_weapon.affectations[CH] if add else chart_of_equipment_modificators[CH] - updated_weapon.affectations[CH]
		##print(chart_of_equipment_modificators[CH])
	##update_stats()

static func update_characteristics(equiped_item, add):
	## print('update_characteristics ', equiped_item)
	for CH in equiped_item.affectations :
		#print(str(CH) + ' # ' + str(equiped_item.affectations[CH]) )
		chart_of_equipment_modificators[CH] = chart_of_equipment_modificators[CH] + equiped_item.affectations[CH] if add else chart_of_equipment_modificators[CH] - equiped_item.affectations[CH]
	update_stats()

static func wear_items(it):
	#print('wear_items')
	Equiped_Items[it.name] = BackPack.Back_Pack[it.name]
	#print(Equiped_Items)
	var Equiped_Item = BackPack.Back_Pack[it.name]
	var ItemClass = Equiped_Item.itemClass.to_lower()
	Equipment_Data[BackPack.Back_Pack[it.name].slot] = BackPack.Back_Pack[it.name].animation
	#print('-> ', ItemClass)
	
	match ItemClass :
		'weapons' :
			if equiped_weapon.size() < 2 :
				equiped_weapon.insert(0, Equiped_Item.unique_id)
			else :
				equiped_weapon[0] = Equiped_Item.unique_id
			Weapons[equiped_weapon[0]] = Equiped_Item	
			Weapon = Weapons[equiped_weapon[0]]
			#update_characteristics(Equiped_Item, true)
		'armors' :
			pass
			#print('aqui')
			#if equiped_armor.size() < 2 :
				#equiped_armor.insert(0, Equiped_Item.unique_id)
			#else :
				#equiped_armor[0] = Equiped_Item.unique_id
			#Ported_armor[equiped_armor[0]] = Equiped_Item	
			#Ported_Armor = Ported_armor[equiped_armor[0]]
			#print( Ported_Armor)
			#update_characteristics(Equiped_Item, true)
		'amulets' :
			#update_characteristics(Equiped_Item, true)
			pass
		'implements' :
			pass
	
	update_characteristics(Equiped_Item, true)
	ANIM_EQUIPMENT_UPDATE = true

static func remove_item(item, dead = false):
	#print('Hero_data ->  unwear item ')

	var Item_to_remove = BackPack.Back_Pack[item.name] if !dead else item
	var Item_name = item.name if !dead else item.unique_id
	#print('DEAD ?  = ', dead )
	var ItemClass = Item_to_remove.itemClass.to_lower()
	#print('Equipment_Data -> to NULL -> ', Equipment_Data[BackPack.Back_Pack[Item_name].slot])	
	Equipment_Data[BackPack.Back_Pack[Item_name].slot] = null #BackPack.Back_Pack[it.name].animation
	#print('BackPack.Back_Pack[Item_name].occupied_slo -> to NULL = ', BackPack.Back_Pack[Item_name].occupied_slot)
	BackPack.Back_Pack[Item_name].occupied_slot = null
	
	match ItemClass :
		'weapons' :
			equiped_weapon.remove_at(0)# erase(Item_to_remove.unique_id)
			Weapons.erase(Item_to_remove.unique_id)
			Weapon = Weapons['Punch']
			#update_characteristics(Item_to_remove, false)
		'armors' :
			equiped_armor.erase(Item_to_remove.unique_id)
			#equiped_armor[0] = Equiped_Item.unique_id
			Ported_armor.erase(Item_to_remove.unique_id)
			Ported_Armor = Ported_armor[equiped_armor[0]]
			#print(Ported_Armor)
		'amulets' :
			pass
		'implements' :
			pass
	
	#if !dead :
	update_characteristics(Item_to_remove, false)
	ANIM_EQUIPMENT_UPDATE = true

func xp_update(nw_xp) :
	#XP += nw_xp
	#xp_updated.emit(XP, difference_btw_levels)
	pass

func check_Level():
	#Aeternus.current_hero_level()
	pass

static func level_up():
	Level += 1
	Next_level = Level + 1
	Points_to_distribute += 3
	TO_LEVEL_UP = true

static func update_health():
	current_health = current_health + bonus_health if (current_health + bonus_health) <= max_health else max_health
	bonus_health = 0
	
static func update_energy():
	Energy = Energy + bonus_energy if (Energy + bonus_energy) <= max_energy else max_energy
	bonus_energy = 0

static func update_mana():
	Mana = Mana + bonus_mana if (Mana + bonus_mana) <= max_mana else max_mana
	bonus_mana = 0
	
static func Invulnerable(potion) :
	state = 'Invulnerable'
	Aeternus.HERO.Invulnerability_Cooldown.set_wait_time((Items_DB.Potions_DB[potion].cooldown + hero_data.Level))
	Aeternus.HERO.Invulnerability_Cooldown.start()	

static func Armor_Potion(potion):
	var bonus = Items_DB.Potions_DB[potion].bonus + Level
	temportal_armor_bonus = bonus
	Aeternus.HERO.Armor_Cooldown.set_wait_time((Items_DB.Potions_DB[potion].cooldown + Level))
	Aeternus.HERO.Armor_Cooldown.start()	
	update_Armor()	

static func update_Armor():
	ported_armor_defence = Ported_Armor.defense
	Armor = natural_armor + ported_armor_defence + temportal_armor_bonus
	Armor_absorption = Ported_Armor.absorption + chart_of_equipment_modificators['Absorption']
	block_absortion =  Armor_absorption + Strength_modificator + temportal_armor_bonus
	Aeternus.HERO.update_status()

static func Strength_potion(potion, dice, dices):
	temporal_strength_modificator = Aeternus.dice_through(dice, dices)
	Aeternus.HERO.Strength_Cooldown.set_wait_time((Items_DB.Potions_DB[potion].cooldown + Level))
	Aeternus.HERO.Strength_Cooldown.start()
	update_Strength()

static func update_Strength():
	max_energy = base_energy + (Strength_modificator * 10) + (Constitution_modificator * 10) + (Dexterity_modificator * 10) + temporal_strength_modificator
	Energy = max_energy
	Charging_speed = Speed + (Strength_modificator * 100) + temporal_strength_modificator
	Damage_modificator = Strength_modificator + temporal_strength_modificator + Weapon.damageBonus #Weapon.damageBonus
	Armor_absorption = Ported_Armor.absorption + chart_of_equipment_modificators['Absorption']
	block_absortion =  Armor + Armor_absorption + temporal_strength_modificator
	Aeternus.HERO.update_status()

static func drink_potion(potion) :
	print('drink potion')
	var char_efect = BackPack.Back_Pack[potion].bonus_afect_to
	var dice = BackPack.Back_Pack[potion].dice
	var dices = BackPack.Back_Pack[potion].dicesQuantity
	if BackPack.Back_Pack[potion].name == 'Recovery Potion' :
		bonus_energy = (float(max_energy) / 100) * dices
		bonus_health = (float(max_health) / 100) * dices
		bonus_mana = (float(max_health) / 100) * dices
		update_energy()
		update_health()
		update_mana()
	elif char_efect.find('Health') > -1 :
		bonus_health = Aeternus.dice_through(dice, dices)
		update_health()	
	elif char_efect.find('Energy') > -1 :
		bonus_energy = Aeternus.dice_through(dice, dices)
		update_energy()
	elif char_efect.find('Mana') > -1 :
		bonus_mana = Aeternus.dice_through(dice, dices)	
		update_mana()
	elif potion.begins_with('Armor') :
		Armor_Potion(potion)
	elif potion.begins_with('Strength') :
		Strength_potion(potion, dice, dices)
	elif potion.begins_with('Invulnerability') :
		Invulnerable(potion)
		
		

static func reset_stats() :
	
	PROGRESS = {'Progress' : {}, 'Missions' : {}, }
	FOLLOWERS = {}
	NOTE_BOOK = {} ## Key events and things to know
	
	Weapons = {
		'Punch' : {
			'name' : 'Punch',
			'damage' : 10,
			'speed' : 6,
			'scope'	: 10,
			'dices' : [1,4],
			'attackBonus' : 0,
			'damageBonus' : 0,
			'attack_scope' : 10,
			'bonus' : 0,
			'magic'	: false,
			'durability' : 100,
			#'Damage_modificator' : 0,
		}
	}

# STATS

	chart_of_equipment_modificators = {
		'Strength' : 0,#Strength ,
		'Constitution' : 0,#Constitution ,
		'Dexterity' : 0,#Dexterity ,
		'Intelligence' : 0,#Intelligence ,
		'Wisdom' : 0,#Wisdom ,
		'Charisma' : 0,#Charisma ,
		'Chance' : 0,#chart_of_equipment_modificators['] #chance_bonus,
		'Attack' : 0,#Item_attack_bonus ,
		'Armor' : 0,#Item_armor_bonus ,
		'Health' : 0,
		'Speed' : 0,
		'Mana' : 0,
		'Energy' : 0,#Item_energy_bonus,
		'Damage' : 0,#Item_damage_bonus,
		'Absorption' : 0,
	}

	Ported_armor = {
		"Natural Armor" : {
			'name' : "Natural Armor",
			'itemClass' : "armor",
			'stackable' : false,
			'stack' : 1,
			'type' : 'skyn_armor',
			'level' : 1,
			'rarity' : "banal",
			'icon' : [8,4],
			'icon_inventary' :  null , #ICON_PATH + "Weapons/morning_star_1.png",
			'animation' : null,
			'speed' : 1,
			'dices' : [0,0],
			'dice': 1,
			'dicesQuantity': 1,
			'bonus': null,
			'damage_type' : null,
			'attack_scope' : 'body', 
			'bonus_afect_to' : 'Armor',
			'state_afected' : null,
			'cooldown' : null ,
			'attackBonus': 0,
			'damageBonus' : 0,
			'defense': 0,
			'absorption' : 0,
			'defenseDice': 0,
			'defenseDicesQuantity': 0,
			'defenseBonus': 0,
			'afectedCharacteristics' : null,
			'bonusToCharacteristic' : null,
		},
	}


	# 	var level = 1 # this info coming from a JSON file

	size = 'medium' # medium, large, extra large, geant, small, extra small, diminute
	speed = 20

	# LOT & ITEMS

	equiped_weapon = ['Punch',]
	Weapon = Weapons[equiped_weapon[0]]
	equiped_armor = ['Natural Armor',]
	#hero_data.Weapons[hero_data.equiped_weapon[0]]Natural Armor['damage']

	Equiped_Items = {}

	TO_UPDATE = false
	ANIM_EQUIPMENT_UPDATE = true
	# Stats 

	alive = true
	state = "Normal" # Normal, Poisoned, trapped, Invulnerable
	# performing = "idle" # Running, Jumping, Charging //  attacking
	# moving = false
	dead_position
	start_position

	Level = 1
	Next_level = Level + 1
	XP = 0
	Points_to_distribute = 0
	difference_btw_levels = 300
	lives = 5
	TO_LEVEL_UP = false 

	Strength = 10
	Constitution = 10
	Dexterity = 10
	Intelligence = 10
	Wisdom = 10
	Charisma = 10

	# Weapon = Items_DB.ITEMS_DB['Punch']
	Embestida
	Ported_Armor =  Ported_armor[equiped_armor[0]] #Items_DB.ITEMS_DB[equiped_armor[0]] #

	Strength_modificator = floor(( (chart_of_equipment_modificators['Strength'] + Strength) - 10) / 2)
	Constitution_modificator =  floor(( (chart_of_equipment_modificators['Constitution'] + Constitution) - 10) / 2)
	Dexterity_modificator =  floor(( (chart_of_equipment_modificators['Dexterity'] + Dexterity) - 10) / 2)
	Intelligence_modificator =  floor(( (chart_of_equipment_modificators['Intelligence'] + Intelligence) - 10) / 2)
	Wisdom_modificator =  floor(( (chart_of_equipment_modificators['Wisdom'] + Wisdom ) - 10) / 2)
	Charisma_modificator =  floor(( (chart_of_equipment_modificators['Charisma'] + Charisma) - 10) / 2)

	temporal_strength_modificator = 0

	base_energy = 100
	Item_energy_bonus = 0 
	max_energy = base_energy + (Strength_modificator * 10) + (Constitution_modificator * 10) + Item_energy_bonus #(Dexterity_modificator * 10) 
	Energy = max_energy  #Current Energy
	regen_energy = 0.01 + (Constitution_modificator / 50)
	bonus_energy = 0
	current_energy = Energy

	#Sprint_energy = 100 + (Strength_modificator * 10) + (Constitution_modificator * 10) + (Dexterity_modificator * 10)

	base_health = 20
	max_health = base_health + Constitution_modificator + chart_of_equipment_modificators['Health'] #health_bonus
	Health = max_health # Current Health
	regen_health = 0.1 + (Constitution_modificator / 10)
	bonus_health = 0

	base_mana = 100 
	max_mana = base_mana + Intelligence_modificator + chart_of_equipment_modificators['Mana'] #mana_bonus
	Mana = max_mana 
	current_mana = Mana
	bonus_mana = 0

	Speed = 20 + (Dexterity_modificator )
	Current_speed = Speed
	Charging_speed = Speed + (Strength_modificator )

	Weapon_speed_modificator = Weapon.speed # Weapons[equiped_weapon[0]].speed # Items_DB.ITEMS_DB[equiped_weapon[0]].speed

	Attack_speed = 9 + Dexterity_modificator + Weapon.speed   # Items_DB.ITEMS_DB[equiped_weapon[0]].speed
	Attack_modifcicator = Dexterity_modificator + Strength_modificator + Weapon.attackBonus + chart_of_equipment_modificators['Attack'] #attack_bonus# Items_DB.ITEMS_DB[equiped_weapon[0]].attackBonus

	Damage_modificator = temporal_strength_modificator + Strength_modificator +  Weapon.damageBonus + chart_of_equipment_modificators['Damage'] #damage_bonus ##Items_DB.ITEMS_DB[equiped_weapon[0]].damageBonus 
	attack_distance =  Weapon.attack_scope # Items_DB.ITEMS_DB[equiped_weapon[0]].attack_scope

	natural_armor = 10
	ported_armor_defence = Ported_Armor.defense + Ported_Armor.defenseBonus + chart_of_equipment_modificators['Armor'] #armor_bonus
	Armor_absorption = Ported_Armor.absorption + chart_of_equipment_modificators['Absorption']
	temportal_armor_bonus = 0

# -------- COOL DOWN -------- #

	armor_cooldown 
	strength_cooldown

# -------- CHANCE -------- #

	Initial_chance = 50
	chance_temporal_bonus = 0
	Chance = Initial_chance + Wisdom_modificator + chance_temporal_bonus + chart_of_equipment_modificators['Chance'] #chance_bonus

# --–––––----- FINAL -------------- #

	Armor = natural_armor + ported_armor_defence + temportal_armor_bonus
	Attack = Attack_modifcicator
	current_health = max_health
	block_absortion =  Armor + Armor_absorption + Strength_modificator
	blocking = false

# ---------- Enemy -------- #

	Enemy_in_attack_range = false 


# ------- Equipment ------- # 

	Equipment_Data = {
		'HEAD' : null,
		'WEAPON' : null,
		'SHIELD' : null,
		'CHEST' : null,
		'BELT' : null,
		'FEET' : null,
		'GLOVES' : null,
	}

	print('Aqui reset el cinturón también')
	Aeternus.HERO.to_update()
	#Aeternus.refresh_hero()
