extends ColorRect

@onready var value = $value

func _ready():
	pass 
	
func _process(delta):
	value.size.x = 138 * (hero_data.XP - Aeternus.XP_LEVELS[str(hero_data.Level)] ) / Aeternus.XP_LEVELS[str(hero_data.Level + 1)]
