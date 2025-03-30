extends CanvasLayer

#@onready var GUI = $"../GUI"
#@onready var Camera = $"../Camera_follow"

@onready var load_window = $Load_window
@onready var btn_1 = $Load_window/Load_stage1
@onready var btn_2 = $Load_window/Load_stage2
@onready var btn_3 = $Load_window/Load_stage3
@onready var ok_btn = $Load_window/Ok_welcome_load
@onready var start = $Start
@onready var select = $Selec

@onready var enter_name_window = $Enter_name_window
@onready var hero_name = $Enter_name_window/Enter_hero_name
@onready var ok_hero_name_btn = $Enter_name_window/OK_enter_name
@onready var cancel_hero_name_btn = $Enter_name_window/Cancel_enter_name


var load_file = null


func _ready():
	#print('READY Welcome Windows')
	Save.load_welcome = [btn_1, btn_2, btn_3]
	#enter_name_window.max_length = 30
	Save.refresh_buttons()
	#start.connect("finished", self, "_on_sound_finished")

func _process(delta):
	if enter_name_window.visible :
		
		if hero_name.text.strip_edges().length() > 0 : #or hero_name.text != ' ' :
			#print(validar_nombre(hero_name.text))
			ok_hero_name_btn.disabled = false
		else :
			ok_hero_name_btn.disabled = true

func _on_start_button_pressed():
	enter_name_window.visible = true
	#queue_free()
	
##### ENTER NAME ######

func _on_ok_enter_name_pressed():
	
	if validar_nombre(hero_name.text) != null :
		hero_data.hero_name = hero_name.text.strip_edges()
		Aeternus.HERO.NAME = hero_name.text.strip_edges()
		print('WELCOME ', hero_data.hero_name)
		Aeternus.change_Scene('Stage_0_00', null, true)
		#Save.load_welcome = []
		start.play()
		await get_tree().create_timer(2.5).timeout
		enter_name_window.visible = false
		ok_hero_name_btn.disabled = true
		visible = false
	else :
		print('please enter a vald name')		


func _on_cancel_enter_name_pressed():
	enter_name_window.visible = false

#func new_game():
	#pass

func _on_welcome_load_button_pressed():
	#Save.load_game('save_game_json')
	load_window.visible = true
	
	#print('Aqui abrir una ventana con los archivos de los juegos anteriores salvados')

func _on_history_button_pressed():
	print('Cuenta la leyenda de una ciudad en llamas y un héroe que salvó a su pueblo de las manos de la esclavitud')


#func delete_current_map():
	#var children = get_parent().get_children()
	#for child in children :
		#if child.is_class("TileMap") :
			#child.queue_free()


func _on_load_stage_1_pressed():
	select.play()
	load_file = 'save_file_1' 
	ok_btn.disabled = false


func _on_load_stage_2_pressed():
	select.play()
	load_file = 'save_file_2'
	ok_btn.disabled = false 


func _on_load_stage_3_pressed():
	select.play()
	load_file = 'save_file_3'
	ok_btn.disabled = false


func _on_ok_welcome_load_pressed():
	if load_file != null :
		#start.play()
		#print('load_file -> ', load_file)
		await get_tree().create_timer(3).timeout
		visible = false
		#queue_free()
		#await get_tree().create_timer(1).timeout
		Save.load_game(load_file)
		load_file = null
		#print('back')


func _on_cancel_welcome_load_pressed():
	load_window.visible = false	
	#Options_screen.visible = false
	load_file = null
	ok_btn.disabled = true



func validar_nombre(hero_name):
	# Permite solo letras y números
	var expresion_regular = RegEx.new()
	expresion_regular.compile("^[a-zA-Z0-9- ]+$")
	return expresion_regular.search(hero_name) != null
