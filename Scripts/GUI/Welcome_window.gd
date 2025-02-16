extends CanvasLayer

@onready var GUI = $"../GUI"
@onready var Camera = $"../Camera_follow"

func _on_start_button_pressed():
	Aeternus.change_Scene('Stage_0_00', true)
	await get_tree().create_timer(1).timeout
	queue_free()

#func new_game():
	#pass

func _on_welcome_load_button_pressed():
	Save.load_game()
	
	print('Aqui abrir una ventana con los archivos de los juegos anteriores salvados')

func _on_history_button_pressed():
	print('Cuenta la leyenda de una ciudad en llamas y un héroe que salvó a su pueblo de las manos de la esclavitud')


func delete_current_map():
	var children = get_parent().get_children()
	for child in children :
		if child.is_class("TileMap") :
			child.queue_free()
