extends CharacterBody2D

## PRELOAD INFORMATIONS 
## Anim
@onready var anim_tree = $animation_tree
@onready var anim_state = anim_tree.get('parameters/playback')
@onready var hero_animation = $hero_animation
@onready var weapon_animation = $Sprite2D/WEAPON
@onready var head_animation = $Sprite2D/HEAD
@onready var chest_animation = $Sprite2D/CHEST
@onready var shield_back_animation = $Sprite2D/SHIELD_back 
@onready var shield_front_animation = $Sprite2D/SHIELD_front
@onready var boots_animation = $Sprite2D/BOOTS
@onready var gloves_animation = $Sprite2D/GLOVES
@onready var belt_animation = $Sprite2D/BELT
@onready var necked_spritesheet_path = 'res://Assets/Images/Spritesheets/necked.png'
@onready var returned_item = preload('res://Scenes/map_items/returned_item.tscn')

## Collistionshapes
@onready var collition_shape = $CollisionShape_base

##Cooldowns
@onready var Invulnerability_Cooldown = $Invulnerability_Cooldown
@onready var Armor_Cooldown = $Armor_Cooldown
@onready var Strength_Cooldown = $Strength_Cooldown

var input_movement =  Vector2.ZERO
var Initial_Position
var returning_from_the_death = false

## STATS 

enum states { MOVE, ATTACK, JUMP, CHARGE, RUN, BLOCK, DEAD }
var Level = hero_data.Level
var XP = hero_data.XP
var current_state = states.MOVE
var current_speed = hero_data.speed
var run_speed = current_speed + 50
var current_health =  hero_data.current_health
var bonus_health = hero_data.bonus_health
var current_armor = hero_data.natural_armor
var current_energy = hero_data.current_energy
var weapon = hero_data.Weapon #Items_DB.ITEMS_DB[hero_data.equiped_weapon[0]]
var Damage_dices = hero_data.Weapon.dices #, hero_data.Weapon.dices[1]] #[Items_DB.ITEMS_DB[hero_data.equiped_weapon[0]].dicesQuantity ,  Items_DB.ITEMS_DB[hero_data.equiped_weapon[0]].dice]
var Damage_bonus = hero_data.Damage_modificator
var Armor = hero_data.Armor
var block_absortion = hero_data.block_absortion
var Attack = hero_data.Attack
var Chance = hero_data.Chance

var blocking = false

func _ready():
	hero_data.alive = true
	$Hero_attack_area/Hero_attack_area_punch.disabled = true
	Initial_Position = global_position
	Aeternus.get_HERO(self)
	
	
func _physics_process(delta):
	
	if hero_data.TO_UPDATE :
		to_update()
	
	match current_state :
		states.MOVE :
			move()
		states.JUMP :
			jump()
		states.ATTACK:
			attack()
		states.BLOCK :
			block()	
		states.CHARGE :
			move()
		states.RUN :
			move()
		states.DEAD :
			dead()
			
	if hero_data.XP >= Aeternus.XP_LEVELS[str(hero_data.Level + 1)] :
		hero_data.level_up()
	

func to_update() :
	Level = hero_data.Level
	XP = hero_data.XP
	current_speed = hero_data.speed
	current_health =  hero_data.current_health
	current_energy = hero_data.current_energy
	bonus_health = hero_data.bonus_health
	current_armor = hero_data.natural_armor
	weapon = hero_data.Weapon 
	Damage_dices = hero_data.Weapon.dices #[0] , hero_data.Weapon.dices[1]]
	Damage_bonus = hero_data.Damage_modificator
	Armor = hero_data.Armor
	block_absortion = hero_data.block_absortion
	Attack = hero_data.Attack
	Chance = hero_data.Chance
	hero_data.TO_UPDATE = false
	Aeternus.get_HERO(self)
	
func move() :
	hero_data.alive = true
	input_movement = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	enable_collisionSahpe()
	
	if hero_data.current_health <= 0 :
		current_state = states.DEAD
		return
	
	if hero_data.ANIM_EQUIPMENT_UPDATE :
		anim_equipment_update()
	
	## if move
	if input_movement != Vector2.ZERO :
		anim_tree.set('parameters/Idle/blend_position', input_movement)
		anim_tree.set('parameters/Walk/blend_position', input_movement)
		anim_tree.set('parameters/Attack/blend_position', input_movement)
		anim_tree.set('parameters/Jump/blend_position', input_movement)
		anim_tree.set('parameters/Run/blend_position', input_movement)
		anim_tree.set('parameters/Block/blend_position', input_movement)
		anim_state.travel('Walk')
		
		if Input.is_action_pressed("Charge") :
			velocity = input_movement * (hero_data.speed + 50) if hero_data.current_energy > 0 else input_movement * hero_data.speed	
			if hero_data.current_energy > 0 :
				anim_state.travel('Run')	
				current_state = states.CHARGE 
				hero_data.current_energy -= 0.2
		else :
			velocity = input_movement * hero_data.speed
		
	if input_movement == Vector2.ZERO :
		anim_state.travel('Idle')
		velocity = Vector2.ZERO
		
	if Input.is_action_just_pressed("Attack") :
		current_state = states.ATTACK
	elif Input.is_action_just_pressed("Jump") :	
		current_state = states.JUMP
	elif Input.is_action_pressed("Block") :
		current_state = states.BLOCK

		
	if hero_data.current_energy < hero_data.max_energy :
		hero_data.current_energy += hero_data.regen_energy		
		
	if hero_data.state == 'Invulnerable':	
		print('INVULNERABLE !!!!')
		$Sprite2D.material.set_shader_parameter('flash_modifier', 0.5)
		#await get_tree().create_timer(0.2).timeout
		#$Sprite2D.material.set_shader_parameter('flash_modifier', 0)
		
	move_and_slide()
	#move_and_collide(velocity * delta)
	
func jump():
	anim_state.travel('Jump')
	velocity = input_movement * (hero_data.speed + 50) if Input.is_action_pressed("Charge") else input_movement * (hero_data.speed + 10)
	move_and_slide()
	
func attack() :
	#$Hero_attackbox/area.get_shape().set_radius(attack_distance)
	anim_state.travel('Attack')
	
func block() :
	if hero_data.current_health > 0 :
		hero_data.blocking = true
		blocking = true
		anim_state.travel('Block')
		if Input.is_action_just_released("Block") :
			hero_data.blocking = false
			blocking = false
			current_state = states.MOVE
	else :
		current_state = states.MOVE		

#func charge() :
#	pass		

func hit(damage):
	if hero_data.state != 'Invulnerable' :
		hero_data.current_health -= damage
		hurt_fx()
	
func hurt_fx():
	$Sprite2D.material.set_shader_parameter('flash_modifier', 0.8)
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.material.set_shader_parameter('flash_modifier', 0)
	
func dead():

	if !returning_from_the_death :
		
		anim_state.travel('Dead')
		print('DEAD')
		hero_data.alive = false
		
		#if !hero_data.emptpy_poquets :
			#pass
		
		## Esto debiera usarlo en caso de tener vidas, pero no.
		##hero_data.lives -= 1
		
		returning_from_the_death = true
		await get_tree().create_timer(4).timeout
		return_items2()
		hero_data.current_health = 0.1
		##hero_data.update_stats()
		hero_data.current_health = hero_data.max_health
		hero_data.current_energy = hero_data.max_energy
		hero_data.XP = Aeternus.XP_LEVELS[str(hero_data.Level)]
		self.global_position = Initial_Position #get_node("%SpawnPosition").global_position
		current_state = states.MOVE
		returning_from_the_death = false
	
	
func return_items2():
	print('RETURN ITEMS 2')
	if !hero_data.alive :
		BackPack.return_equiped_items()
		for remove in hero_data.Equiped_Items :
			hero_data.remove_item(hero_data.Equiped_Items[remove], true)
		hero_data.Equiped_Items = {}
			
			## tomar los slots y tomar su posicion en el espacio (300, -250) por ejemplo
			## con esta información podre acceder a 
			## Equiped.get_item.under.position(position)
		## print(hero_data.get_container_position())
			## esto retornará un item, el que tiene la imagen y características. 
			## Este se poderá eliminar. 
		pass	

func return_items():
	## ATENCIÓN AQUÍ ES DONDE SE GENERA EL ERROR DEL INVENTARIO!!!!!!
	print('ATENCIÓN AQUÍ ES DONDE SE GENERA EL ERROR DEL INVENTARIO!!!!!!  func return_items(): en Hero.gd')
	if !hero_data.alive :
		
		print('Hero.gd : 227 ', hero_data.Equiped_Items)
		
		for remove in hero_data.Equiped_Items :

			print('Hero.gd : 231 ', hero_data.Equiped_Items[remove])
			
			##  ME PREGUNTO SI hero_data.Equiped_Items[remove] NO ESTÁ
			## ENTREGANDO EL OBJETO EN EL BUEN FORMATO O
			## NO CONTIENE TODA LA INFORMACIÓN NECESARIA
			## QUE LA SIGUEINTE FUNCIÓN hero_data.remove_item NECESITA
			## PARA PROCESAR EL ITEM Y DEAR EL ESPACIO LIMPLIO
			
			hero_data.remove_item(hero_data.Equiped_Items[remove], true)
		
		hero_data.Equiped_Items = {}
		
		for to_zero in hero_data.chart_of_equipment_modificators :
			hero_data.chart_of_equipment_modificators[to_zero] = 0
		
		for item in BackPack.Back_Pack :
			print('Hero.gd : 247 ', item)
			var rd_value = RandomNumberGenerator.new()
			var the_thing = returned_item.instantiate()
			the_thing.Data = BackPack.Back_Pack[item]
			the_thing.position = global_position
			the_thing.position.x = global_position.x + randf_range(-10, 10)
			the_thing.position.y = global_position.y + randf_range(-10, 10) 
			get_tree().get_root().add_child(the_thing)
			print('HELLO?')
		
		BackPack.Treasure['Coins'] -= floor(BackPack.Treasure['Coins'] / 2)
		BackPack.Back_Pack = {}
		
		print('Hero.gd : 260 ', 'Important Items')
		print(!BackPack.Important_Items.is_empty())
		if !BackPack.Important_Items.is_empty():
			for importantItem in BackPack.Important_Items :
				BackPack.Back_Pack[importantItem] = BackPack.Important_Items[importantItem]
			BackPack.Important_Items = {}	
		
		#hero_data.emptpy_poquets = true

func anim_equipment_update ():
	for path in hero_data.Equipment_Data :
		if hero_data.Equipment_Data[path] != null :
			match path :
				'WEAPON' :
					weapon_animation.texture = load(hero_data.Equipment_Data[path])
				'CHEST' :
					chest_animation.texture = load(hero_data.Equipment_Data[path])	
				'HEAD' :
					head_animation.texture = load(hero_data.Equipment_Data[path])
				'SHIELD' :	
					shield_back_animation.texture = load(hero_data.Equipment_Data[path].replace('.png', '_back.png'))
					shield_front_animation.texture = load(hero_data.Equipment_Data[path].replace('.png', '_front.png'))
				'FEET':
					boots_animation.texture = load(hero_data.Equipment_Data[path])
				'GLOVES' : 
					gloves_animation.texture = load(hero_data.Equipment_Data[path])	
				'BELT' :
					belt_animation.texture = load(hero_data.Equipment_Data[path])		
		else :
			match path :
				'WEAPON' :
					weapon_animation.texture = load(necked_spritesheet_path)
				'CHEST' :
					chest_animation.texture = load(necked_spritesheet_path)	
				'HEAD' :
					head_animation.texture = load(necked_spritesheet_path)	
				'SHIELD' :	
					shield_back_animation.texture = load(necked_spritesheet_path)	
					shield_front_animation.texture = load(necked_spritesheet_path)
				'FEET':
					boots_animation.texture = load(necked_spritesheet_path)
				'GLOVES' : 
					gloves_animation.texture = load(necked_spritesheet_path)
				'BELT' :
					belt_animation.texture = load(necked_spritesheet_path)
	
	hero_data.ANIM_EQUIPMENT_UPDATE = false	
	

func on_state_reset():
	current_state = states.MOVE
	
func disable_collisionShape() :
	$CollisionShape_base.disabled = true
func enable_collisionSahpe() :
	$CollisionShape_base.disabled = false

func update_status():
	Level = hero_data.Level
	XP = hero_data.XP
	current_state = states.MOVE
	current_speed = hero_data.speed
	run_speed = current_speed + 50
	current_health =  hero_data.current_health
	bonus_health = hero_data.bonus_health
	current_armor = hero_data.natural_armor
	weapon = hero_data.Weapons[hero_data.equiped_weapon[0]]
	Damage_dices = hero_data.Weapons[hero_data.equiped_weapon[0]].dices  #equiped_weapon[0]  #[Items_DB.ITEMS_DB[hero_data.equiped_weapon[0]].dicesQuantity ,  Items_DB.ITEMS_DB[hero_data.equiped_weapon[0]].dice]
	Damage_bonus = hero_data.Damage_modificator
	Armor = hero_data.Armor
	Attack = hero_data.Attack
	Chance = hero_data.Chance

func _on_strength_cooldown_timeout():
	hero_data.temporal_strength_modificator = 0
	hero_data.update_Strength()
	update_status()

func _on_armor_cooldown_timeout():
	hero_data.temportal_armor_bonus = 0
	hero_data.update_Armor()
	update_status()

func _on_invulnerability_cooldown_timeout():
	hero_data.state = 'Normal'
