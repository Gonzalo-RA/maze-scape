extends CanvasLayer

@onready var menu_screen = $Menu_Screen

# Called when the node enters the scene tree for the first time.
func _ready():
	Aeternus.get_GUI(self)
	pause_game() 
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_save_button_pressed():
	Save.save_game() # $Inventory , $Inventory_/Equiped 

func _on_load_button_pressed():
	Save.load_game() # $Inventory_, $Inventory_/Equiped

func pause_game():
	get_tree().paused = !get_tree().paused 
	menu_screen.visible = get_tree().paused
	Aeternus.IS_GAME_PAUSED = get_tree().paused

func _on_menu_button_pressed():
	pause_game() 
