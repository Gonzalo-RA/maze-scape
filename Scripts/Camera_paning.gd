extends Camera2D

@export var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
#	var map_rect = map.get_used_rect()
#	var tile_size = map.cell_quadrant_size
#	var world_size = map_rect.size * tile_size
	
#	limit_right = world_size.x
#	limit_bottom = world_size.y
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position
	var x = floor(position.x / 320 ) * 320
	var y = floor(position.y / 180 ) * 180
	position = Vector2(x,y)
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'position', Vector2(x,y) , 0.14)
