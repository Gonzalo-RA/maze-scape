extends Node2D

var next_stage

func _ready():
	Aeternus.get_SCENE(self)

func _on_leaving_area_01_body_entered(body):
	next_stage = 'Stage_0_01'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, false)
		print('Hero Entered to Leaving area 00')

func _on_leaving_area_00_body_entered(body):
	next_stage = 'Stage_0_00'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, false)
		print('Hero Entered to Leaving area 00')
