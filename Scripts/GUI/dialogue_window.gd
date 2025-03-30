extends CanvasLayer

@onready var Text_container = $Text_Container
@onready var Start = $Text_Container/Panel/MarginContainer/HBoxContainer/Start
@onready var Text_Area = $Text_Container/Panel/MarginContainer/HBoxContainer/Text
@onready var Continue = $Text_Container/Panel/MarginContainer/HBoxContainer/Continue
# Called when the node enters the scene tree for the first time.
@onready var btn_0x = $btn_0x # $Text_Container/Panel/MarginContainer/btn_0x
@onready var talk_portrait = $Text_Container/Panel/MarginContainer/HBoxContainer/Portrait_block/portrait

var hero_portrait
var pnj_portrait

var dialogue = "Hola compade, como estas espero que super bien en toda la vida. Haia una vez un compañero que se creía la raja y por hueón vinieron y le lo limpiaron jajajaj" 

var read_rate = 0.05

enum read_state {HIDEN, READY, READING, WAITING, FINISHED}
var enum_states = ['HIDEN', 'READY', 'READING', 'WAITING', 'FINISHED']

var reading_state = read_state.HIDEN

var tween : Tween
var PNJ = { 'name' : 'Magonzalo' , 'pnj_PNJ_Name' : 'Magonzalo'}
#var pnj_name = "Magonzalo"
#var pnj_PNJ_Name = "Magonzalo"

var text_count = 0
var current_dialog = 'greetings'
var Mission_Script
var talk_started = false 

func _ready():
	#Mission_Script = Example_Mission_Script
	set_default()
	hero_portrait = load(hero_data.Portrait_path)
	#change_reading_states(read_state.READY)
	#dialogue_manager(PNJ, Mission_Script)

func _process(delta):
	match reading_state :
		read_state.HIDEN :
			hide()
		read_state.READY :
			#print('read_state.READY')
			show()
			dialogue_manager(PNJ, Mission_Script)
		read_state.READING :
			if Input.is_action_just_pressed("ui_accept"):
				tween.kill() 
				add_continue_text()
		read_state.WAITING :
			pass		
		read_state.FINISHED :
			if Input.is_action_just_pressed("ui_accept"):
				accept()

func show_text_box() :
	Start.text = ''
	#Text_container.show()

func display_text(text):
	Text_Area.text = text
	Text_Area.visible_ratio = 0
	change_reading_states(read_state.READING)
	#show_text_box()
	tween = create_tween()
	tween.tween_property(Text_Area, 'visible_ratio', 1.0, text.length() * read_rate)
	tween.tween_callback(add_continue_text)
	
func add_continue_text():
	Continue.text = 'V'
	Text_Area.visible_ratio = 1
	change_reading_states(read_state.FINISHED)
	
func _on_continue_pressed():
	if Text_Area.visible_ratio == 1 :
		add_continue_text()
	
func accept():
	change_reading_states(read_state.READY)
	dialogue_manager(PNJ, Mission_Script)
	
func change_reading_states(next_state) :
	reading_state = next_state

func set_default() :
	change_reading_states(read_state.HIDEN)
	Start.text = ''
	Text_Area.text = ''
	Continue.text = ''
	current_dialog = 'greetings'
	talk_started = false 
	pnj_portrait = null

func select_btn(strll):
	strll.get_parent().get_node('PanelContainer').get_node('Estrellita').text = '*  '
func deselect_btn(strll):
	strll.get_parent().get_node('PanelContainer').get_node('Estrellita').text = ''

func end_dialogue(pnj):
	print('end_dialogue')
	Aeternus.end_dialog()
	#if Mission_Script.reward != 'follow_hero' :
		#pnj.resume_behaviour()

func _on_btn_00_mouse_entered(this):
	select_btn(this)
func _on_btn_00_mouse_exited(this):
	deselect_btn(this)

### MANAGE DIALOGUE ###

func dialogue_manager(pnj, Mission_Script):
	print('dialogue_manager')
	if pnj.PNJ_Name == '' : 
		print(' no PNJ Name')
		return
	if  pnj.Mission_name == '' :
		print('No Mission Name')
		return 
	if reading_state != read_state.READY :
		print('reading_state != read_state.READY')
		return
	if pnj.Interaction != pnj.INTERACTION.IMPORTANT :
		print('pnj.Interaction != pnj.INTERACTION.IMPORTANT')
		return
		
	var text
	#if hero_data.PROGRESS.Missions.has(Mission_Script.mission_name) :
		#Mission_Script = hero_data.PROGRESS.Missions[Mission_Script.mission_name]
		#print('MISSION ALREADY EXISTS')
	print(pnj.PNJ_Name)
	var Dialog = Mission_Script[pnj.PNJ_Name] 
	#print(Dialog)
	var pnj_is_arget = false 
	text = define_next_dialog(pnj, Dialog)
	define_portrait(pnj, text)
	
	if text.begins_with(':') and text.ends_with(':') :
		text = changing_section(pnj, text, Dialog, Mission_Script)
		if text == null :
			return
	
	text_count += 1
	display_text(text)

func changing_section(pnj, text, Dialog, Mission_Script):
	print('changing_section')
	text_count = 0
	text = clean_text(text) 
	if text.contains('_end_'):
		print("text.contains('_end_')")
		if text.contains('_true_') :
			if text.contains('_end_true_end_') :
				Mission_Script.completed = true
				end_mission()
			if Dialog.is_requester :
				Mission_Script.accepted = true
				#store_mission()
			elif Dialog.is_target :
				keep_in_backback(pnj, Dialog)
				define_action(pnj, Dialog)
		if text.contains('_open_shop_') :
			print('_open_shop_')
			pnj.open_shop()
			Aeternus.Inventory.inventory_on = true
		set_default()
		end_dialogue(pnj)
		return
	elif text.contains('options_')	:
		var i = 0
		for option in Mission_Script[pnj.PNJ_Name].dialog[text] :
			## buttons 
			var btn = add_btns(i, clean_text(option[1]), option[0])
			change_reading_states(read_state.WAITING)
			Text_Area.text = ''
			i += 1
		return
	current_dialog = text
	text = Mission_Script[pnj.PNJ_Name].dialog[current_dialog][text_count]
	return text

func add_btns(i, btn_name, in_text):
	var block = btn_0x.duplicate()
	btn_0x.get_parent().add_child(block)
	var h = btn_0x.get_custom_minimum_size()
	var pos = btn_0x.get_position()
	block.visible = true
	block.name = 'blck_btns_'
	block.position = Vector2(pos.x, pos.y + (h.y * i) + 2)
	var btn = block.get_node('btn_00')
	btn.set_text(in_text)
	btn.name = btn_name
	btn.pressed.connect(on_selected_answer_pressed.bind(btn))
	btn.mouse_entered.connect(_on_btn_00_mouse_entered.bind(btn))
	btn.mouse_exited.connect(_on_btn_00_mouse_exited.bind(btn))
	return btn

func on_selected_answer_pressed(button):
	print('on_selected_answer_pressed')
	current_dialog = button.name
	#print(current_dialog)
	change_reading_states(read_state.READY)
	remove_buttons()
	
func remove_buttons():
	for btns in get_children() :
		if btns.name.contains('blck_btns_') :
			btns.queue_free()
	
func clean_text(txt):
	return txt.trim_prefix(':').trim_suffix(':')

func define_next_dialog(pnj, person):
	var text
	if Mission_Script.completed :
		## completed
		text = person.dialog.say_hi[text_count]
	elif Mission_Script.accepted and !Mission_Script.completed : # and Mission_Script.waiting
		## accepted but not completed, so waiting 
		
		if !talk_started :
			current_dialog = 'waiting' if !person.is_target else 'target_found'
			talk_started = true
		
		if person.is_requester :
			if BackPack.Back_Pack.has(Mission_Script.target) :
				print('BackPack.Back_Pack.has(Mission_Script.target)')
				if hero_data.FOLLOWERS.has(Mission_Script.target) :
					print('hero_data.FOLLOWERS.has(Mission_Script.target)')
					if hero_data.FOLLOWERS[Mission_Script.target]['name'] == BackPack.Back_Pack[Mission_Script.target].target :
						## Aquí tendremos que definir todas las posibles acciones que el pj tome
						## luego de finalizar la mision. Estas pueden ser diversas y difíciles de establecer.
						## Desde : seguir a otro pj , desaparecer, caminar hacia otra parte, quedar esperando
						## También podría tener que reaccionar de cierta manera luego
						## En el caso de Blind Guy se quitará su zona de interacción 
						BackPack.Back_Pack[Mission_Script.target].object.follow(pnj)
						BackPack.Back_Pack[Mission_Script.target].object
						BackPack.Back_Pack.erase(Mission_Script.target)
						hero_data.FOLLOWERS.erase(Mission_Script.target)
						current_dialog = 'thanks'
						define_reward(pnj)
		text = person.dialog[current_dialog][text_count] 
	elif !Mission_Script.accepted and !Mission_Script.completed :
		## almost first time
		print('current_dialog -> ', current_dialog)
		text = person.dialog[current_dialog][text_count] if !current_dialog.contains('_end_') else str(':' + current_dialog + ':')
	print(text)
	return text

func define_portrait(pnj, text):
	print('define_portrait')
	if pnj_portrait == null:
		pnj_portrait = load(pnj.Portrait)
	talk_portrait.set_texture(pnj_portrait)
	if text.contains('hero_') or text.contains('options_'):
		talk_portrait.set_texture(hero_portrait)
	print('define_portrait')

#func give_item(item):
	#print(item)

func define_reward(pnj):
	match Mission_Script.reward :
		'follow_hero' 	:
			hero_data.FOLLOWERS[pnj.PNJ_Name] = {'name' : pnj.PNJ_Name}
			pnj.follow(Aeternus.HERO)
		'give_item' 	:
			Aeternus.give_item(Mission_Script.item)	
		'give_info' 	:
			Aeternus.give_info(Mission_Script.info)
		'level_up' 		:
			pass
		'info' 			:
			pass
		'gold' 			:
			pass
		'open_door' 	:
			pass

func define_action(pnj, person):
	match person.after_found:
		'follow_hero' 	:
			hero_data.FOLLOWERS[pnj.PNJ_Name] = {'name' : pnj.PNJ_Name}
			pnj.follow(Aeternus.HERO)
		'give_item' 	:
			Aeternus.give_item(person)	
		'give_info' 	:
			Aeternus.give_info(person)
		'level_up' 		:
			pass
		'info' 			:
			pass
		'gold' 			:
			pass
		'open_door' 	:
			pass
		
#func store_mission():
	#if !hero_data.PROGRESS.Missions.has(Mission_Script.mission_name) :
		#hero_data.PROGRESS.Missions[Mission_Script.mission_name] = Mission_Script
		##'mission_name' :  Mission_Script.mission_name ,
		##'description' :  Mission_Script.description ,
		##'completed' :  Mission_Script.completed ,
		##'target' :  Mission_Script.target ,
		##'requester' :  Mission_Script.requester ,
		##'reward' :  Mission_Script.reward ,
		##'participants' : Mission_Script.participants,
	#

func keep_in_backback(pnj, person):
	BackPack.Back_Pack[person.name] = {
		'name'		: person.name,
		'target' 	: Mission_Script.target,
		'is_target' : person.is_target,
		'mission_name' : Mission_Script.mission_name,
		"itemClass" : 'mission_object',
		#"reward" : person.reward,
		"type" 		: person.after_found, ## follow_hero
		"importantItem": true,
		"object" 	: pnj,
	}

func end_mission():
	Mission_Script.completed = true

var Example_Mission_Script = {
	"Blind as a P I T" : {
		'mission_name'	: "Blind as a P I T",
		'participants'	: ['Magonzalo', 'Blind_guy'],
		'accepted'		: false,
		'completed'		: false,
		'target'		: 'Blind guy',
		'requester'		: 'Magonzalo',
		'description'	: "Find a blind man near to THE PIT and bring him back to his friend",
		'reward'		: 'give_item',  ## info # level_up # gold # 
		'item'			: {'name' : 'Key'},
		'Magonzalo' 	: {
			'name' 			: 'Magonzalo',
			'mission_name' 	: "Blind as a P I T",
			'is_requester'	: true,
			'waiting'		: false,
			'is_target'		: false,
			'dialog'		: {
				'greetings'	: [ "Hola compade, como estas espero que super bien en toda la vida. Haia una vez un compañero que se creía la raja y por hueón vinieron y le lo limpiaron jajajaj",
								"Necesito que alguien me ayude a encontrar a mi amigo.", "Estaráis dispuesto a ayudarme?", ":options_01:"],
				"options_01" : [
									["Si, por su puesto", ":explanation:"],
									["no, no tengo tiempo",":negate:"],
								],
				"negate"	: ["Bueno no importa, gracias ... por nada","Gallina", ":end:"],
				"explanation" : ["Mi amigo se fue cerca de un sitio llamado \"THE PIT\"", "Visto que el tipo es ciego, temo que pueda harle pasado algo", "Podrías por favor traerlo de vuela?", "Te puedo dar una recompensa", ":options_02:"],
				"options_02" : [
									["Esta bien, no te precupes, yo iré por tu amigo", ":acepte:"],
									["Na me da lata, pejor preguntale a alguien más",":negate_02:"],
								],
				"acepte"	: ["Genial, muchisimas gracias, estaré esperando aquí", ":end_true:"],
				"negate_02"	: ["Gallina... ", ":end:"],
				'intro'		: [ "Había una vez un perrito que se llamaba calcetín ..",
								"un día salió a la calle ...",
								"y se lo puseron!", ":end:"],
				'waiting'	: ["Hey! y mi amigo? done está ? ", "No me ire a casa sin el", ":end:"],
				'say_hi'	: ["Siempre me acordaré de ti por la ayuda que nos diste", ":end:"]
			},
		},
		'Blind_guy'	:  {
			'name' 			: 'Blind_guy',
			'mission_name' 	: "Blind as a P I T",
			'waiting'		: false,
			'is_target'		: true,
			'is_requester'	: false,
			'after_found'	: 'follow_hero', ## follow_hero # give_item # give_info # level_up # info # gold # open_door #
			'description'	: "Find a blind man near to THE PIT and bring him back to his friend",
			'dialog'		: {
				'greetings'		: [ "Quien está ahí? ...",
									"no logro ver nada...",
									":end:"],
				'target_found'	: ["I'm lost ... I can't see ... I can't go back home..,", ":ayuda:"],
				"ayuda"		  	: ["Me puedes ayudar para volver a casa?", ":options_01:"],
				"options_01"	: [
									["No, pudrete aquí solo viejo loco", ":end:"],
									["Talvez ... Que me darás a cambio?", ":a_cambio:"],
									["Tu amigo está preocupado por ti, ven, te llevaré con él",":gracias:"],
								],
				"gracias"		: ["Te lo agradezco mucho tu me indicas por donde ir", ":end_true:"],
				'a_cambio'		: ["Bueno, la verdad es que no tengo mucho aquí para darte, sólo me quedaba un pan y ya lo comí.",
								"Pero estoy seguro que mi amigo te ofrecerá algo si me ayudas", ":ayuda:"],
			}
		},
	},
	
	'Walker' 	: {
		'name' 			: 'Magonzalo',
		'mission_name' 	: "Blind as a P I T",
		'accepted'		: false,
		'completed'		: false,
		'waiting'		: false,
		'is_target'		: false,
		'target'		: 'Blind_guy',
		'requester'		: 'Magonzalo',
		'reward'		: 'item',
		'item'			: {'name' : 'Key'},
		'description'	: "Find a blind man near to THE PIT and bring him back to his friend",
		'dialog'		: {
		'greetings'		: [ "Hola compade, como estas espero que super bien en toda la vida. Haia una vez un compañero que se creía la raja y por hueón vinieron y le lo limpiaron jajajaj",
								"Necesito que alguien me ayude a encontrar a mi amigo.", "Estaráis dispuesto a ayudarme?", ":options_01:"],
						}
	},
}

#var SCRIPT = {
	#'Magonzalo' : {
				#'mission name'	: ["Blind as a P I T"],
				#'description'	: ["Find a blind man near to THE PIT and bring him back to his friend"],
				#'requester'		: 'Magonzalo',
				#'accepted' 		: false,
				#'completed'		: false,
				#'target'		: 'Blind_guy',
				#'intro' 		: [["quest intro"],["Hola compade, como estas espero que super bien en toda la vida. Haia una vez un compañero que se creía la raja y por hueón vinieron y le lo limpiaron jajajaj"]],
				#'background'	: [['goodbye'], ["Había una vez un perrito que se llamaba calcetín ...",
									#"un día salió a la calle ...",
									#"y se lo puseron!"]],
				#'quest intro' 	: [['answer_set_1'], ["Me podrías ayudar a encontrar a mi compa ? ", "Te puedo recompenzar"]],
				#'answer_set_1' 	: [['consecuence_0', 'consecuence_1'],
									#["Yes, of course",
									#"Man, I'm very busy now, I cant helpyou"]],
				#'consecuence_0' : [['question_2'], ["That's great, thanks man!" ]],
				#'consecuence_1' : [['goodbye'], ["No problem, I'll find some one else"]],
				#'question_2'	: [['answer_set_2'], ["My frind was lost in the mountains, near of \"THE PIT\"",
									#"He's blind and I#m afraid that he is lost"]],
				#'answer_set_2'	: [['consecuence_2', 'consecuence_3'], ["Don't worry, I'll be back with your fiend",
									#"do you said \"THE PIT\"? ... I'm sorry, that makes me afraid"]],
				#'consecuence_2' : [['acepte'], ["You are the best, Thanks", "I'll give you an special present if you come bak with my friend"]],
				#'consecuence_3' : [['background'], ["Oh, well. You're no more than a schiken, thanks anyway."]],
				#'acepte'		: [[null],["And once again, thank you very much"],[true]],			
				#'goodbye'		: [[null],["have a good day."],[false]],
				#'waiting_mission'	: [['explanation'],["did you find my friend?", "I've got to go home with him"]],
				#'explanation'	: [[null], ["I really will not go homw without my friend, so please find him."], [true]],
				#'thanks'		: [['give a item'],["oh, man, thanks you very much for bringin my friend back" ]],
				#'give a item'	: [['adios_'],["as a demostration of gratitud I want to ofer you this key" ]],
				#'adios_'		: [[null],['Estaré aquí para darte consejos, muchas gracias'],[true]],
				#'greet_after'   : [[null],["Estoy agracedido por haber traido a mi amigo de vuelta"]],
				#'item'			: "key",
				#'result'		: 'give item',
				#
					#},
	#'Walker'	: {
				#'greetings'		: "I'm busy man ..."
	#},
	#'Blind_guy'	: {
				#'mission name'	: ["Blind as a P I T"],
				#'requester'		: 'Magonzalo',
				#'completed'		: false,
				#'accepted'		: false,
				#'greetings'		: "I'm lost ... I can't see ... I can't go back home..",
				#'intro' 		: [['explain'], ["Who is there? ... I can't see"]],
				#'explain'		: [['back_home'], ["I'm lost and I don't know ho to go back home"]],
				#'back_home'		: [[null], ["Can you help me to go back home?"], [true]],
				#'result'		: 'follow_hero', ## follow_hero // give item // give info // rise level // power ... 
	#}
#}
