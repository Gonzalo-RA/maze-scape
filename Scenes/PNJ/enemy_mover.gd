extends CharacterBody2D
class_name enemy_mover
#class_name pnj_mover

# PRELOAD INFORMATIONS
# @onready var pnj_data = preload("res://Assets/Images/Background/maps-assets.png")
enum PNJ_TYPE {PNJ, ENEMY, FRIEND}

@onready var loot_data = preload('res://Scenes/map_items/loot_items.tscn')
@export var Type_of_PNJ : PNJ_TYPE
@export var Monster_list : Monsters_DB.MONSTER_LIST
@export var Level = 1

var rng = RandomNumberGenerator.new()

var Monster
var Max_health
var Health 
var Current_health 
var Speed
var Loot_value  # num of coins or bojects

var Enemy = false
var PNJ = false
var Friend = false
var Hero
var Hero_to_chase = false
var alive = true
var given_XP = false
var given_loot = false

enum pnj_states {MOVE_FRONT, MOVE_BACK, MOVE_LEFT, MOVE_RIGHT, DEAD}
var performing = 'Idle' # 'Chasing', 
var current_state = pnj_states.MOVE_FRONT
var direction = Vector2.ZERO
var patroll_direction

var Enemy_name
var Enemy_class
var Enemy_level
var Enemy_race

var Original_Speed # = 100
#var Speed # = Original_Speed
var Random_timeout = 3
var Chasing_speed # = 260 #50
var Chasing_moral # = 200
var Chasin_Perseption # = 300

var ready_to_attack = true

var Weapon # = Items_DB.ITEMS_DB['Arabic Sword']
var attack_distance # = Weapon.attack_scope
var attack_speed # = 1 # from weapon

var Attack # = 2 # Monsters.attackBonus
var Defense_bonus
var Armor = 11 # Monsters.defense + dice_through(Monsters.defenseDicesQuantity, Monsters.defenseDice)  
var Damage # damageBonus + weapon damage
var Damage_dices
var Damage_bonus

var Current_direction
		
func Stats_calculation() :
	if Type_of_PNJ == 0 :
		PNJ = true
	elif Type_of_PNJ == 1 :
		Enemy = true
	elif Type_of_PNJ == 2 :
		Friend = true
	
	if Enemy :
		Monster = Monsters_DB.MOSNTER[Monsters_DB.Monster_name_list[Monster_list]]
		Max_health = Aeternus.dice_through(Monster.healthDices[0] * Level , Monster.healthDices[1])
		Health = Max_health
		Current_health = Health
		Speed = Monster.originalSpeed
		Loot_value = Monster.treasure_type # Treasure_DB... something
		Enemy_name = Monster.name
		Enemy_class = Monster.class
		Enemy_level = Level
		Enemy_race = Monster.race
		Original_Speed = Speed
		Chasing_speed = Monster.chasingSpeed 
		Chasing_moral = Monster.chasingMoral 
		Chasin_Perseption = Monster.chasingPerception 
		Weapon = Items_DB.Weapons_DB[Monster.weapon]
		attack_distance = Weapon.attack_scope
		attack_speed = Weapon.speed 	
		Attack = Monster.attackBonus + Weapon.attackBonus
		Defense_bonus = Monster.defenseBonus
		Armor = Monster.defense + Defense_bonus
		Damage_bonus = Monster.damageBonus + Weapon.damageBonus
		Damage_dices = [Weapon.dicesQuantity , Weapon.dice]
	
	
func _physics_process(delta):
	
	if Current_health <= 0 :
		current_state = pnj_states.DEAD 
		dead()
	else :
		
		if !Aeternus.IS_TALKING_SCENE :
			if performing == 'Chasing' && alive :
				to_chase(Hero)	
			elif Enemy && performing == 'Attacking' && alive :
				attack()
				return
			else :	
				match current_state: 
					pnj_states.MOVE_FRONT :
						move_front()
					pnj_states.MOVE_BACK :
						move_back()
					pnj_states.MOVE_LEFT :
						move_left()
					pnj_states.MOVE_RIGHT :
						move_right()
					pnj_states.DEAD :
						dead()			
			
			var collision = move_and_collide(velocity * delta)
			
			if collision:
				if collision.get_collider().name == 'Ground' :
					random_walk()
		# move_and_slide()
	
func random_walk() :
	patroll_direction = randi() % 4
	if patroll_direction == Current_direction :
		random_walk()
		return
	else :
		Current_direction = patroll_direction
		random_direction()

func random_direction():
	match patroll_direction :
		0 :
			current_state = pnj_states.MOVE_FRONT 
		1 :
			current_state = pnj_states.MOVE_BACK
		2 : 
			current_state = pnj_states.MOVE_LEFT
		3 :
			current_state = pnj_states.MOVE_RIGHT

func move() :
	velocity = direction * Speed
	$animation.play('Walk_' + returned_direction(direction))

func move_front():
	velocity = Vector2.DOWN * Speed
	$animation.play('Walk_Front')
	
func move_back():
	velocity = Vector2.UP * Speed
	$animation.play('Walk_Back')

func move_left():
	velocity = Vector2.LEFT * Speed
	$animation.play('Walk_Left')

func move_right():
	velocity = Vector2.RIGHT * Speed
	$animation.play('Walk_Right')

func attack():
	if !Friend :
		performing = 'Attacking'
		$animation.play('Attack_' + returned_direction(direction))
		await $animation.animation_finished
		performing = 'Chasing'

func dead() :
	Speed = 0
	alive = false
	if !given_XP :
		given_XP = true
		hero_data.XP += 100 * Enemy_level
	$animation.play('Dead')
	await $animation.animation_finished
	loot()
	queue_free()

func loot() :
	if !given_loot :
		var treasure = Items_DB.generate_loot(Loot_value)
		for L in treasure :
			while treasure[L] > 0 :
				var the_loot = loot_data.instantiate()
				if L != 'Coins' :
					the_loot.random_generated = true
					the_loot.Random_Generated_Category = L
				the_loot.position.x = global_position.x + randf_range(-10, 10)
				the_loot.position.y = global_position.y + randf_range(-10, 10) 
				get_tree().get_root().add_child(the_loot)
				treasure[L] -= 1
		given_loot = true

func to_chase(Hero_):
	Hero_to_chase = true
	Hero = Hero_
	var Hero_distance = Hero.position - position
	
	if alive && Hero_distance.length() <= Chasin_Perseption:
		Speed = Chasing_speed
		direction = Hero_distance.normalized()
		if Hero_distance.length() <= attack_distance :
			direction = Hero_distance.normalized()
			attack()
		move()	
	elif alive && Hero_distance.length() > Chasin_Perseption :
		Speed = Original_Speed
		performing = 'Idle'
		$Random_walking_timer.set_wait_time(rng.randf_range(0, Random_timeout))
		$Random_walking_timer.start()

func returned_direction(direction : Vector2):
	var normalized_direction  = direction.normalized()
	var default_return = "Front"
	var X = normalized_direction.x
	var Y = normalized_direction.y	
	
	if Y > 0.3  &&  X > 0.3 :
		return "Front_Right"
	elif  Y > 0.3  &&  X < -0.3 :
		return "Front_Left"
	elif  Y < -0.3  &&  X > 0.3 :
		return "Back_Right"
	elif  Y < -0.3  &&  X < -0.3 :
		return "Back_Left"
	elif  X > 0  &&  Y > -0.2  &&  Y < 0.2 :
		return "Right"
	elif  X < 0  &&  Y > -0.2  &&  Y < 0.2:
		return "Left"
	elif  Y > 0.3:
		return "Front"
	elif Y < 0.3:
		return "Back"
		
	return default_return
