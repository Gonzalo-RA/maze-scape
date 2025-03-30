extends CanvasLayer

@onready var menu_screen = $Menu_Screen
@onready var Options_screen = $Menu_Screen/Options_Screen
@onready var Save_screen = $Menu_Screen/Options_Screen/Save_Screen
@onready var Load_screen = $Menu_Screen/Options_Screen/Load_Screen

###

@onready var confirmation_window = $Menu_Screen/Confirmation_Dialog_Window
@onready var confirmation_load_button = $Menu_Screen/Confirmation_Dialog_Window/OK_confirm
@onready var cancel_load_button = $Menu_Screen/Confirmation_Dialog_Window/Cancel_confirm

###

#@onready var Talk_Window = $Talk_Window
@onready var Dialogue_Window = $Dialogue_Window

var ACTION = null ## null || LOAD || HOME || OVERWRITE


var save_file
var load_file
# Called when the node enters the scene tree for the first time.
func _ready():
	print('Ready GUI')
	Save.saves_buttons = [	$Menu_Screen/Options_Screen/Save_Screen/Save_btn1,
							$Menu_Screen/Options_Screen/Save_Screen/Save_btn2,
							$Menu_Screen/Options_Screen/Save_Screen/Save_btn3,
						]
	Save.load_buttons = [	$Menu_Screen/Options_Screen/Load_Screen/Load_btn1,
							$Menu_Screen/Options_Screen/Load_Screen/Load_btn2,
							$Menu_Screen/Options_Screen/Load_Screen/Load_btn3,
						]
						
	Save.refresh_buttons()
	Aeternus.get_GUI(self)
	pause_game()


func _on_save_button_pressed():
	Options_screen.visible = true
	Save_screen.visible = true

func _on_load_button_pressed():
	Options_screen.visible = true
	Load_screen.visible = true

func pause_game():
	print('GAME PAUSED : ', get_tree().paused)
	if get_tree().paused == true :
		get_tree().paused = false
	else :
		get_tree().paused = true
	#get_tree().paused = !get_tree().paused 
	menu_screen.visible = get_tree().paused
	Aeternus.IS_GAME_PAUSED = get_tree().paused
	print('Aeternus.IS_GAME_PAUSED : ', Aeternus.IS_GAME_PAUSED)

func _on_menu_button_pressed():
	pause_game() 

func _on_back_home_screen_pressed():
	confirmation_window.visible = true
	ACTION = 'HOME'
	
func _on_resume_game_button_pressed():
	pause_game()

func _on_history_nd_missions_button_pressed():
	print('Aqui abrir una ventada de las misiones realizadas y a realizar')
	pass # Replace with function body.


###### SAVE SCREEN ########

func _on_save_btn_1_pressed():
	save_file = 'save_file_1'
	print(save_file)
func _on_save_btn_2_pressed():
	save_file = 'save_file_2'
	print(save_file)
func _on_save_btn_3_pressed():
	save_file = 'save_file_3'
	print(save_file)


### no lo estoy usando
func _on_ok_save_btn_pressed():
	## Test if the button is used
	ACTION = 'OVERWRITE'
	confirmation_window.visible = true
	#Save.save_game(save_file)

func _on_cancel_save_btn_pressed():
	Save_screen.visible = false
	Options_screen.visible = false
	save_file = null
	ACTION = null


####### LOAD SCREEN #########

func _on_load_btn_1_pressed():
	load_file = 'save_file_1'
func _on_load_btn_2_pressed():
	load_file = 'save_file_2'
func _on_load_btn_3_pressed():
	load_file = 'save_file_3'
	
func _on_ok_load_btn_pressed():
	ACTION = 'LOAD'
	confirmation_window.visible = true

func _on_cancel_load_btn_pressed():
	Load_screen.visible = false	
	Options_screen.visible = false
	load_file = null


######## CONFIRM DIALOG ##########

func _on_ok_confirm_pressed():
	confirmation_window.visible = false
	if ACTION == 'HOME' :
		Aeternus.to_home_sceen()
	elif ACTION == 'LOAD' :	
		Save.load_game(load_file)
	elif ACTION == 'OVERWRITE' :
		Save.save_game(save_file)
	
func _on_cancel_confirm_pressed():
	confirmation_window.visible = false
	load_file = null

######### TALKINS SCENES ########

#func switch_talking_window():
#	Talk_Window.visible = Aeternus.IS_TALKING_SCENE
#	Talk_Window.get_node('Continue_text_bnt').visible = Aeternus.IS_TALKING_IMPORTANT_SCENE

#var answer_options
#func _on_continue_text_bnt_pressed():
	#var next_text = Aeternus.talking_next()
	##if typeof(next_text) == 28:
	##print('next_text -> ', next_text)
	#if next_text == null :
		#return
	#elif next_text[1] != null : ## hay preguntasa y respuestas 
		#var i = 0
		#var btn_1 = $Talk_Window/Text_area.get_node('Btn_00')
		#for answer in next_text[1] :
			##print('answer -> ', answer)
			##print('consecuence -> ', str(next_text[1][i]))
			#var option_answer = btn_1.duplicate()
			#var buton_name = answer #.duplicate()
			#option_answer.name = str(buton_name) #'consecuence_' + str(i) 
			#option_answer.set_text( next_text[0][i] )
			#option_answer.visible = true
			#option_answer._set_position(Vector2(0, (15 * i)))
			#$Talk_Window/Text_area.add_child(option_answer)
			#i += 1
		#for button in $Talk_Window/Text_area.get_children():
			#if button.name != 'Btn_00' :
				#button.pressed.connect(_on_pressed.bind(button))
		#$Talk_Window/Continue_text_bnt.visible = false
	#else : ## No hay respuestas 
		#$Talk_Window/Text_area.set_text( next_text[0] )
		##print('_on_continue_text_bnt_pressed')
#
#func _on_pressed(button):
	#Aeternus.dialog_next = button.name
	#Aeternus.next_text = -1
	#for btn in $Talk_Window/Text_area.get_children():
		##button.pressed.disconnect(_on_pressed.bind(button))
		#if btn.visible :
			#btn.queue_free() 
	#_on_continue_text_bnt_pressed()
	#$Talk_Window/Continue_text_bnt.visible = true
	#print(button.name, " was pressed")


	#pass # Replace with function body.
