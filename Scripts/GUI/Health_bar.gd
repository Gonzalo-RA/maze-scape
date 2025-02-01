extends ColorRect

@onready var value = $value

func update_health_bar() :
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value.size.x = 138 * hero_data.current_health / hero_data.max_health
	#pass
