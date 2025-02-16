extends Camera2D

@export var player : CharacterBody2D
@export var map : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	resise_and_position(map)
	Aeternus.get_camera(self)

func _process(delta):
	position = player.position

func resise_and_position(new_map):
	var map_rect = new_map.get_used_rect()
	var tile_size = new_map.cell_quadrant_size
	var world_size = map_rect.size * tile_size
	limit_right = world_size.x
	#limit_left =  world_size.x 
	limit_bottom = world_size.y

func get_map():
	var children = get_parent().get_children()
	for child in children :
		if child.is_class("Node2D") :
			if child.name.contains('Stage_') or child.name.contains('World_Map') :
				print(StagesDB.Stages[child.name].name)
				var new_Stage = child.get_children()
				for ns_child in new_Stage :
					if ns_child.is_class("TileMap"):
						resise_and_position(ns_child)
