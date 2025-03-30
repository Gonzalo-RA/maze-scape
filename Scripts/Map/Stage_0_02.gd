extends map_config


# Called when the node enters the scene tree for the first time.
func _ready():
	Aeternus.get_SCENE(self)


func _on_leaving_area_01_body_entered(body):
	if body.name == 'Hero':
		print('Entered in leaving zone ')


func _on_leaving_area_00_body_entered(body):
	if body.name == 'Hero':
		print('Entered in leaving zone ')
