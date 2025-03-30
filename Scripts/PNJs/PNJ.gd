#extends CharacterBody2D
extends pnj_mover
class_name PNJ

@onready var Interaction_area = $Interaction_Area
@onready var PNJ_animation = $PNJ_animation

## SKIN
@onready var Body_skin = $Sprite2D
@onready var Hair_skin = $Sprite2D/HAIR
@onready var Eye_skin = $Sprite2D/EYE
@onready var Deard_skin = $Sprite2D/BEARD

## Clothes
@onready var Shirt_skin = $Sprite2D/SHIRT
@onready var Dress_skin = $Sprite2D/DRESS
@onready var Slip_skin = $Sprite2D/SLIP
@onready var Trousers_skin = $Sprite2D/TROUSERS
@onready var Shoes_skin = $Sprite2D/SHOES
@onready var Gloves_skin = $Sprite2D/GLOVES_skin

## Armor
@onready var Shield_back = $Sprite2D/SHIELD_back
@onready var Shield_front = $Sprite2D/SHIELD_front
@onready var Weapon_skin = $Sprite2D/WEAPON
@onready var Chest = $Sprite2D/CHEST
@onready var Head = $Sprite2D/HEAD
@onready var Boots = $Sprite2D/BOOTS
@onready var Belt_armor = $Sprite2D/BELT
@onready var Gloves_armor = $Sprite2D/GLOVES

#var Current_health

@onready var Random_walking_timer = $Random_walking_timer

var HERO_is_CLOSE
var Response
var Is_Talking = false
var mission_cumplida = false

func _ready() :
	
	if PNJ_class == PNJ_TYPE.MERCHANT :
		#Merch_Inventory = Aeternus.Merchant_Inventory
		set_merchandise()
	
	if Interaction == INTERACTION.STATIC :
		Interaction_area = false
		$Interaction_Area.queue_free()
	elif Interaction == INTERACTION.SIMPLE :	
		pass
	elif Interaction == INTERACTION.IMPORTANT :	
		pass	
	
	PNJ_ANIM = PNJ_animation
	
	if  Random_skyn :
		Skin_color = randi_range(0, Aeternus.Colors_DB.size() - 1)
		Eye_color = randi_range(0, Aeternus.Colors_DB.size() - 1)
		Hair = randi_range(0,Aeternus.Hair_DB.size() - 1 )
		Hair_color = randi_range(0, Aeternus.Colors_DB.size() - 1)
		Beard = randi_range(0,Aeternus.Beart_DB.size() - 1 )
		Beard_color = randi_range(0, Aeternus.Colors_DB.size() - 1)
		
	var color_of_skin = load(skin_path + 'Body/body/body_' + Aeternus.Colors_DB[Skin_color] + '.png')
	Body_skin.texture = color_of_skin
	var color_of_eye = load(skin_path + 'Body/eye/eye_' + Aeternus.Colors_DB[Eye_color] + '.png')
	Eye_skin.texture = color_of_eye
	if Aeternus.Hair_DB[Hair] != 'bald' :
		var hair_style = load(skin_path + 'Body/hair/hair_' + Aeternus.Hair_DB[Hair] + '_' + Aeternus.Colors_DB[Hair_color] + '.png')
		Hair_skin.texture = hair_style
	if Aeternus.Beart_DB[Beard] != null :
		var beard_style = load(skin_path + 'Body/beard/beard_' + Aeternus.Beart_DB[Beard] + '_' + Aeternus.Colors_DB[Beard_color] + '.png')
		Deard_skin.texture = beard_style
		
	if  Random_clothes :
		Shirt = randi_range(0, Aeternus.Shirt_DB.size() - 1)
		Shirt_color = randi_range(0, Aeternus.Colors_DB.size() - 1)
		Belt = randi_range(0, Aeternus.Colors_DB.size() - 1)
		Gloves = randi_range(0, Aeternus.Colors_DB.size() - 1)
		Shoes = randi_range(0, Aeternus.Colors_DB.size() - 1)
		Trouser = randi_range(0, Aeternus.Colors_DB.size() - 1)
		
	var shirt_skin = load(str( skin_path + 'Clothes/shirt/shirt_' + Aeternus.Shirt_DB[Shirt] + '_' + Aeternus.Colors_DB[Shirt_color] + '.png'))
	Chest.texture = shirt_skin
	var belt_style = load(skin_path + 'Clothes/slip/slip_' + Aeternus.Colors_DB[Belt] + '.png')
	Belt_armor.texture = belt_style
	var gloves_style = load(skin_path + 'Clothes/gloves/gloves_' + Aeternus.Colors_DB[Gloves] + '.png')
	Gloves_armor.texture = gloves_style
	var shoes_style = load(skin_path + 'Clothes/shoes/shoes_' + Aeternus.Colors_DB[Shoes] + '.png')
	Boots.texture = shoes_style
	var trousers_skyn = load(skin_path + 'Clothes/trouser/trouser_' + Aeternus.Colors_DB[Trouser] + '.png')
	Trousers_skin.texture = trousers_skyn
		
	if Weapon > 0 :
		var weapon_name = Items_DB.Weapons_name_list[Weapon].replace(' ', '_').to_lower()
		print(weapon_name)
		var weapon_skin = load('res://Assets/Images/Spritesheets/Weapons/' + weapon_name + '_' + str(weapon_power) + '.png')
		print('res://Assets/Images/Spritesheets/Weapons/' + weapon_name + '_' + str(weapon_power) + '.png')
		Weapon_skin.texture = weapon_skin
	
	Response = Aeternus.PNJ_behavour_DB[Behaviour]
	resume_behaviour()

func _on_random_walking_timer_timeout():
	if current_state != pnj_states.WAITING and current_state != pnj_states.TALKING :
		random_walk()
		Random_walking_timer.set_wait_time(rng.randf_range(0, Random_timeout))
		Random_walking_timer.start()

func _on_interaction_area_body_entered(body):
	if body.name == 'Hero':
		if !mission_cumplida :
			if !following :
				HERO_is_CLOSE = true
				Random_walking_timer.stop()
				current_state = pnj_states.TALKING
				if PNJ_class == PNJ_TYPE.MERCHANT :
					print('soy mercader')
					#open_shop()
					#.inventory_on = true

func _on_interaction_area_body_exited(body):
	if body.name == 'Hero' : #and Interaction != INTERACTION.IMPORTANT:
		HERO_is_CLOSE = false
		Aeternus.IS_TALKING_SCENE = false
		#Aeternus.GUI.switch_talking_window()
		if !following :
			resume_behaviour()

func resume_behaviour():
	print('resume behaviour')
	match Response:
		'waiting' :
			current_state = pnj_states.WAITING
			#waiting()
		'walking': 
			current_state = pnj_states.MOVE_FRONT
			_on_random_walking_timer_timeout()
		'folow after action':
			current_state = pnj_states.WAITING
			pass

func open_shop():
	Aeternus.Inventory.ShopStore_grid.ShopStore = Merchant_pack
	Aeternus.Inventory.ShopStore_grid.set_shop()
	#BackPack.add_to_bag(ITEM, Merchant_pack)

func set_merchandise():
	var rd_value = RandomNumberGenerator.new()
	var ITEM
	#print(Merchandise)
	print('aqui generar random items')
	var Merch_Category = Aeternus.iterate_dictionary_by_index(Items_DB.TREASURE, 3)
	var Object_list = Items_DB.generate_loot(Merch_Category)
	#print(Object_list)
	for item in Object_list :
		if item != 'Coins' and item != 'Gems':
			var DB_name = item + '_DB'
			match  item :
				'Potions' :
					var Potion_ = Items_DB.Potions_name_list[rd_value.randi_range(1, Items_DB.Potions_name_list.size() - 1)]
					ITEM = Items_DB.potion_maker(Items_DB[DB_name][Potion_].duplicate(true))
				'Armors' :
					pass
				'Weapons' :
					pass
				'Keys' :
					pass
			
			if ITEM != null :
				Merchant_pack[ITEM.unique_id] = ITEM
			##	BackPack.add_to_bag(ITEM, Merchant_pack)
			
	##Aeternus.Merchant_Inventory.set_merchandise(Merchant_pack)
	
