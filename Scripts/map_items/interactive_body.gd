extends Interactive_Static_Body

var PNJ_Name 
func _ready():
	PNJ_Name = Object_Name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interactive_area_area_entered(area):
	print('entered')
	if area.name == 'Hero_attack_area' :
		HERO_is_CLOSE = true 

func _on_interactive_area_area_exited(area):
	if area.name == 'Hero_attack_area' :
		pass
		#HERO_is_CLOSE = false 
		#Is_Talking = false 
