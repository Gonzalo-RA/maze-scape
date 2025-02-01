extends pnj_mover

# ENEMY

#stats 
#var Monster 
#var Attack

  # it determines the size of the Radar / detection_area
var blocking =  false

func _ready():
	Stats_calculation()
	random_walk()
	
func _on_timer_timeout():
	random_walk()
	$Random_walking_timer.set_wait_time(rng.randf_range(0, Random_timeout))
	$Random_walking_timer.start()

func hurt_fx():
	$sprite.material.set_shader_parameter('flash_modifier', 0.8)
	await get_tree().create_timer(0.2).timeout
	$sprite.material.set_shader_parameter('flash_modifier', 0)
	
func _on_radar_body_entered(body):
	if body.is_in_group('Heroes') :
		$Random_walking_timer.stop()
		performing = 'Chasing'
		to_chase(body)
	
func _on_hitbox_area_entered(area):
	if area.is_in_group('Hero_attack') :
		Aeternus.match_Attack(area.get_parent() , self)

func hit(damage):
	Current_health -= damage
	hurt_fx()

func _on_attack_area_area_entered(area):
	if  area.name == 'Hitbox' :
		Aeternus.match_Attack(self, area.get_parent()) 
