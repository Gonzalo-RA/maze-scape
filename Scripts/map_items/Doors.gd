extends StaticBody2D
class_name doors
#export (String) var ID_number

enum DOOR_POSITION {FRONT, LEFT, RIGHT}
@export var door_position : DOOR_POSITION
var positions = ['Front', 'Left', 'Right']
@onready var Door_Position = positions[door_position]

@export var Needs_Key = true
@export var Door_instance_ID : int = 100000000 ## for normal door use "00"
@export var Is_bleakable = true
@export var Hit_points : int = 100
enum DOOR_MATERIAL {WEAK_WOOD, NORMAL_WOOD, STRONG_WOOD, GOOD_GATE, DUNGEON_GRILLE, GRILLE_GATE, STONE, STONE_GATE}
@export var door_materieal : DOOR_MATERIAL 
var materials = ['Weak Wood', 'Normal Wood', 'Strong Wood', 'Good Gate', 'Dungeon Grille', 'Grille Gate', 'Stone', 'Stone Gate']
@onready var Doors_Materials = materials[door_materieal]
@export var Special = false

@onready var Sprite = $Sprite
@onready var Shape = $Shape
@onready var Hitbox = $Hit_Box_Area

var closed = true

func _ready():
	pass

func _process(delta):
	if closed :
		$open_the_door.play('closed')

func hit() :
	pass

func open() :
	#print('door open -> animation to open ')
	closed = false
	$open_the_door.play('open_the_door')
	Shape.queue_free()
	Hitbox.queue_free()
	
func get_key() :
	var code
	var keychain
	for item in BackPack.Back_Pack :
		if Needs_Key :
			if item.contains('single_key_'):
				for key_code in BackPack.Back_Pack[item]['open_code'] :
					if key_code == Door_instance_ID :
						keychain = BackPack.Back_Pack[item]
						code = key_code
						open()
		else :
			if item.contains('normal_key_'):
				keychain = BackPack.Back_Pack[item]
				code = 00
				open()
	if code == null :
		return
	else :
		var the_keychain_element = Aeternus.Inventory.get_node(keychain['unique_id'])
		var the_children = Aeternus.Inventory.get_node(keychain['unique_id']).get_children()
		var the_label = the_children[0]
		var the_stack = int(the_label.text)
		var the_new_stack = 0
		if the_stack >= 1 :
			the_new_stack = the_stack - 1
		if the_new_stack <= 0 :
			the_keychain_element.queue_free()
		else :
			if the_new_stack <= 1 :
				the_new_stack = ''
			the_label.set_text(str(the_new_stack))
			the_keychain_element.set_meta('stack', the_new_stack)
		keychain['stack'] = the_new_stack
		keychain['stock'] = the_new_stack
		keychain['open_code'].pop_at(keychain['open_code'].find(code))
		if keychain['open_code'].is_empty() :
			BackPack.Back_Pack.erase(keychain)
		print('finished the key')

func _on_hit_box_area_area_entered(area):
	if area.name == 'Hero_attack_area' :
		get_key()
		
		#$crate_animation.play('Open')
		#await $crate_animation.animation_finished
		#loot()
		#queue_free()
