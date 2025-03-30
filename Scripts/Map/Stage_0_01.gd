extends map_config


# Called when the node enters the scene tree for the first time.
func _ready():
	Aeternus.get_SCENE(self)
	

func _on_leaving_area_00_body_entered(body):
	next_stage = 'Stage_0_00'
	Arriving_Area = '01'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, Arriving_Area, false)


func _on_leaving_area_01_body_entered(body):
	if body.name == 'Hero':
		print('Entered in leaving zone ')
