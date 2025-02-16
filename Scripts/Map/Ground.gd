extends TileMap

#@onready var Starting_Point = $Srtart_Area
#@onready var leaving_area_01 = $Leave_Area_01
#@onready var leaving_area_02 = $Leave_Area_02


# Called when the node enters the scene tree for the first time.
func _ready():
	Aeternus.get_SCENE(self)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_leave_area_01_body_entered(body):
	#if body.name == 'Hero' :
		#print('LEAVING AREA')
#
#func _on_leave_area_02_body_entered(body):
	#if body.name == 'Hero' :
		#print('LEAVING AREA')
