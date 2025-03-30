extends StaticBody2D
class_name Interactive_Static_Body

@export_category("General Caracteristics")

@export var Object_Name : String = ''
@export var Kind_of_body = ''
@export_file("*.png") var Portrait : String = '' 
@export_file("*.png") var Animation_Skin : String = '' 

@export_category("Interactividad")
enum BEHAVOUR {WAITING, RANDOM_WALKING, FOLOW_AFTER_ACTION}
enum INTERACTION {STATIC, SIMPLE, IMPORTANT}
@export var Behaviour : BEHAVOUR
@export var Interaction : INTERACTION

@export_group("Roll in the Game")
@export var Mission_name : String = ''

@export_subgroup ("Mission")
@export var Mission_requester : bool = false
@export var Mission_target : bool = false
@export var object_giving : String = ''
@export var After_Mission : Dictionary = {
			'Position' : Vector2(), 'State' : ''
			}

var HERO_is_CLOSE = false 
var Is_Talking = false 
#var Portrait = null

func talk() :
	pass
