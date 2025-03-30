extends StaticBody2D

@onready var loot_data = preload('res://Scenes/map_items/loot_items.tscn')


enum LOOT_TYPE { A, B, C, D, E , F, G, H, I, J, K, L, M, N, O, P, }
@export var Loot_Category : LOOT_TYPE
var Loot_list = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',]	

var given_loot = false 
var Loot_value = Loot_list[Loot_Category]

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_hitbox_area_entered(area):
	if area.name == 'Hero_attack_area' :
		$crate_animation.play('Open')
		await $crate_animation.animation_finished
		loot()
		queue_free()

func loot() :
	if !given_loot :
		var treasure = Items_DB.generate_loot(Loot_value)
		#print(treasure)
		for L in treasure :
			if L == 'Coins' :
				while treasure[L] > 0 :
					var coins = loot_data.instantiate()
					coins.position.x = global_position.x + randf_range(-10, 10)
					coins.position.y = global_position.y + randf_range(0, 10) # + (randf_range(- 20 , 20))
					get_tree().get_root().add_child(coins)
					treasure[L] -= 1
			else :
				while treasure[L] > 0 :
					var the_loot = loot_data.instantiate()
					#the_loot.Loot_category = L
					the_loot.random_generated = true
					the_loot.Random_Generated_Category = L
					the_loot.position.x = global_position.x + randf_range(-10, 10)
					the_loot.position.y = global_position.y + randf_range(0, 10) # + (randf_range(- 20 , 20))
					get_tree().get_root().add_child(the_loot)
					treasure[L] -= 1
		given_loot = true
