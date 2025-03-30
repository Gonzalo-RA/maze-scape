extends Control

@onready var accepting = $Accepting_
@onready var confirm = $Confirmation_

var CONFIRMED = false
var ACCEPTED = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_confirmation__confirmed():
	CONFIRMED = true
	print('CONFIRMED -> ', CONFIRMED)
	#return true

func _on_confirmation__canceled():
	print('CANCEL')
	return false

func _on_accepting__confirmed():
	ACCEPTED = true
	print('ACCEPTED')
	return true
	
