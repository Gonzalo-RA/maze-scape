extends Camera2D

@export var player : CharacterBody2D
@export var map : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	print('READY Camera Follow')
	resise_and_position(map)
	Aeternus.get_camera(self)
	print('ready camera')

func _process(delta):
	#print('camera normal')
	position = player.position
	#print('process')

func resise_and_position(new_map):
	print('resise_and_position')
	print(new_map.get_parent().name)
	if new_map.get_parent().name.contains("World_Map") :
		print('YES is world map ')
		self.set_zoom(Vector2(2,2))
	else :
		print("no, it's no a World Map")
		self.set_zoom(Vector2(4,4))
	player = Aeternus.HERO
	var map_rect = new_map.get_used_rect()
	var tile_size = new_map.cell_quadrant_size
	var world_size = map_rect.size * tile_size
	limit_right = world_size.x
	#limit_left =  world_size.x 
	limit_bottom = world_size.y
	print('END  - Camera')

func get_map():
	print('CAMERA get_map')
	var children = get_parent().get_children()
	for child in children :
		if child.is_class("Node2D") or child.is_class('map_config'):
			if child.name.contains('Stage_') or child.name.contains('World_Map') :
				#print(StagesDB.Stages[child.name].name)
				var new_Stage = child.get_children()
				for ns_child in new_Stage :
					if ns_child.is_class("TileMap"):
						resise_and_position(ns_child)
