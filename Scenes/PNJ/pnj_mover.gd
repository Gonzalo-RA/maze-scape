extends CharacterBody2D
class_name pnj_mover


var skin_path = 'res://Assets/Images/Spritesheets/Skins/'
var inventory_path = "res://Scenes/UI/inventory_.tscn"
var Merch_Inventory

enum COLORS {YELLOW, BLACK, WHITE, BROWN, GRAY_LIGHT, GRAY_DARK, GREEN_LIGHT, GREEN_DARK, BLUE_DARK, BLUE_LIGHT, RED_LIGHT, RED_DARK, MAGENTA_LIGHT, MAGENTA_DARK, CYAN_LIGHT, CYAN_DARK, RANDOM }
enum PNJ_TYPE {COUNTRY_PERSON, SLAVE, WORKER, MERCHANT, CITY_PERSON, COURTIER, MILITAR, RANDOM }
enum RACE {HUMAN, ORC, DWARF, RANDOM}
enum GENDER  {MALE, FEMALE, OTHER, RANDOM }
enum ALIGNEMENT  {NEUTRAL, GOOD, EVIL}

@export_category("Caracterísitcas generales")

@export var PNJ_Name : String = ''
@export var PNJ_class : PNJ_TYPE
@export var Race :  RACE
@export var Gender : GENDER

@export_group("Roll in the Game")
@export var Mission_name : String = ''
@export_subgroup ("Mission")
@export var Mission_requester : bool = false
@export var Mission_target : bool = false
@export var object_giving : String = ''
@export var Alignement : ALIGNEMENT
@export var After_Mission : Dictionary = {
	'Position' : Vector2(), 'State' : ''
}
## After complete mission ... Position, State, reaction

## Behaviour
@export_category("Interactividad")
enum BEHAVOUR {WAITING, RANDOM_WALKING, FOLOW_AFTER_ACTION}
enum INTERACTION {STATIC, SIMPLE, IMPORTANT}
@export var Behaviour : BEHAVOUR
@export var Interaction : INTERACTION


@export_group("Marchant")
@export var Merchandise = ''
var Merchant_pack = {}

@export_group("Fisics characteristics")
@export_range(1.0, 20.0, 0.5) var Speed : float = 5.0

## SKYN
@export_category("Apariencia")
enum BEARD {NULL, BABILONIC, FULL, GOATEE, LONG, NORMAL, STAP, RANDOM}
enum HAIR {SHORT, LONG, THICK, PUFFY, BALD, RANDOM}
@export_file("*.png") var Portrait : String = '' 
@export var Random_skyn = false

@export_group("Skin Characteristics")
@export var Skin_color : COLORS
@export var Eye_color : COLORS
@export var Hair : HAIR
@export var Hair_color : COLORS
@export var Beard : BEARD 
@export var Beard_color : COLORS

## CLOTHES
@export_group("Clothes")
enum SHIRT {T_SHIRT, SHIRT, DRESS, RANDOM}
@export var Random_clothes = false
@export var Shirt : SHIRT
@export var Shirt_color : COLORS
@export var Belt : COLORS
@export var Trouser : COLORS
@export var Gloves : COLORS
@export var Shoes : COLORS

## WEAPONS
@export_group("Weapons")
enum WEAPONS { NULL, BATTLE_AXE, WAR_AXE, CLUB, LONG_SWORD, ARABIC_SWORD, MORNINGSTAR, WAR_HAMMER, }
@export var Weapon : WEAPONS
@export_range(1, 8) var weapon_power: int = 1

#Aeternus.Colors_DB

var rng = RandomNumberGenerator.new()

#var Monster
#var Max_health
#var Health 
#var Current_health 
#var Speed
#var Loot_value  # num of coins or bojects

var Enemy = false
var PNJ = false
var Friend = false
var Hero = false
var following = false
var alive = true
var given_XP = false
var given_loot = false
var Followed = null

enum pnj_states {MOVE_FRONT, MOVE_BACK, MOVE_LEFT, MOVE_RIGHT, IDLE_LEFT, IDLE_FRONT, IDLE_RIGHT, IDLE_BACK, WAITING, TALKING, FOLLOWING, DEAD}
var performing = 'Idle' # 'Chasing', 
var current_state = pnj_states.MOVE_FRONT
var direction = Vector2.ZERO
var patroll_direction
var Current_direction

var Random_timeout = 3

var PNJ_ANIM

var Current_health = 100
var Follow_Perseption = 40
var Follow_speed = 20

#var Mission_follow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	PNJ_Name = self.name if PNJ_Name != '' else PNJ_Name

func _physics_process(delta):
	
	if Current_health <= 0 :
		current_state = pnj_states.DEAD 
		#dead()
	else :	
		if !Aeternus.IS_TALKING_SCENE :
			if performing == 'Chasing' && alive :
				pass
				#to_chase(Hero)	
			elif Enemy && performing == 'Attacking' && alive :
				#attack()
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
						pass
						#dead()	
					pnj_states.TALKING :
						talk()
					pnj_states.FOLLOWING :
						follow(Followed)
					pnj_states.WAITING :
						waiting()
								
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
	PNJ_ANIM.play('Walk_' + returned_direction(direction))

func move_front():
	velocity = Vector2.DOWN * Speed
	PNJ_ANIM.play('Walk_Front')
	
func move_back():
	velocity = Vector2.UP * Speed
	PNJ_ANIM.play('Walk_Back')

func move_left():
	velocity = Vector2.LEFT * Speed
	PNJ_ANIM.play('Walk_Left')

func move_right():
	velocity = Vector2.RIGHT * Speed
	PNJ_ANIM.play('Walk_Right')
	
func  idle_front():
	pass

func waiting():
	velocity = Vector2.RIGHT * 0
	PNJ_ANIM.play('Waiting')

func talk():
	velocity = Vector2.RIGHT * 0
	PNJ_ANIM.play('Idle_Front')
	
func follow(followed):
	current_state = pnj_states.FOLLOWING
	following = true
	Followed = followed 
	var Followed_distance = Followed.position - position
	if alive and Followed_distance.length() <= Follow_Perseption and Followed_distance.length() > 7:
		Speed = Follow_speed
		direction = Followed_distance.normalized()
		move()	
	elif Followed_distance.length() <= 7 :
		performing = 'Idle'
		direction = Followed_distance.normalized()
		waiting()
	elif alive && Followed_distance.length() > Follow_Perseption :
		Speed = 5
		performing = 'Idle'
	
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
