extends Node2D

@onready var Start_Point = $Leaving_Area_00
@onready var Leaving_Area_00 = $Leaving_Area_00
@onready var Leaving_Area_01 = $Leaving_Area_01
@onready var Leaving_Area_02 = $Leaving_Area_02
var next_stage

var Start_position
# Called when the node enters the scene tree for the first time.
func _ready():
	Start_position = Start_Point.position
	Aeternus.HERO.Initial_Position = Start_position
	print(Start_position)

func _on_leaving_area_00_body_entered(body):
	next_stage = 'Stage_0_01'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, false)
		print('Hero Entered to Leaving area 00')

func _on_leaving_area_01_body_entered(body):
	next_stage = 'Stage_0_02'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, false)
		print('Hero Entered to Leaving area 00')

func _on_leaving_area_02_body_entered(body):
	next_stage = 'World_Map'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, false)
		print('Hero Entered to Leaving area 02')
