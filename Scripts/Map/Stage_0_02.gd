extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Aeternus.get_SCENE(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_leaving_area_01_body_entered(body):
	if body.name == 'Hero':
		print('Entered in leaving zone ')


func _on_leaving_area_00_body_entered(body):
	if body.name == 'Hero':
		print('Entered in leaving zone ')
