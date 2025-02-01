extends Camera2D

@export var player : CharacterBody2D
@export var map : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var map_rect = map.get_used_rect()
	var tile_size = map.cell_quadrant_size
	var world_size = map_rect.size * tile_size
	
	limit_right = world_size.x
	limit_bottom = world_size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position
