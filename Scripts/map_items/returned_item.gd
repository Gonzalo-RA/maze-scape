extends Area2D

@onready var Sprite = $Item_Sptrite

var ITEM
var Data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	ITEM = Data
	Sprite.set_frame_coords(Vector2i(ITEM.icon[0],ITEM.icon[1]))

func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == 'Hero':
		#print(ITEM)
		if ITEM != null and hero_data.alive :
			BackPack.add_to_bag(ITEM) 
			queue_free()	
