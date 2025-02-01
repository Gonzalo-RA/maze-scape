extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_pressed():
	Save.save_game($Inventory_, $Inventory_/Equiped)


func _on_load_button_pressed():
	Save.load_data($Inventory_, $Inventory_/Equiped)
