extends ColorRect

@onready var value = $value

func update_health_bar() :
	pass

func _ready():
	pass # Replace with function body.

func _process(delta):
	value.size.x = 138 * hero_data.current_energy / hero_data.max_energy
