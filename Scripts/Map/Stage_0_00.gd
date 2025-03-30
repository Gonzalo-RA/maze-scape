extends map_config

@onready var Start_Point = $Start_Area
@onready var Leaving_Area_00 = $Leaving_Area_00
@onready var Leaving_Area_01 = $Leaving_Area_01
@onready var Leaving_Area_02 = $Leaving_Area_02
@onready var Map = $Map

@onready var Magonzalo = $Map/Magonzalo
@onready var Walker = $Map/Walker
@onready var Blind_guy = $Map/Blind_guy
@onready var Green_square = $Map/Green_square
@onready var Merchant = $Map/Merchant

#var Talk_window
#var Text_area

# Called when the node enters the scene tree for the first time.
func _ready():
	Start_position = Start_Point.position
	Aeternus.HERO.Initial_Position = Start_position
	Aeternus.get_SCENE(self)
	
	PNJ_group = [Magonzalo, Walker, Blind_guy, Green_square, Merchant]
	history_progressions_consecuences()
	
	for mission in hero_data.PROGRESS.Missions :
		if hero_data.PROGRESS.Missions[mission].completed :
			for pnj in PNJ_group :
				if hero_data.PROGRESS.Missions[mission].target == pnj.name :
					print('la mision ya está completa, el pnj debe reaccionar de una manera')
					print('provablemente el pnj deba estar en otoro lugar o simplemente no estar')
				elif hero_data.PROGRESS.Missions[mission].requester == pnj.name :
					print('la mision ya está completa, el pnj debe reaccionar de una manera')
					
func _process(delta):
	for pnj_ in PNJ_group :
		if pnj_.HERO_is_CLOSE and !pnj_.Is_Talking:
			#Aeternus.pnj_talk(pnj_, SCRIPT) #, Text_area)
			Aeternus.active_dialogue_window(pnj_, SCRIPT)

func _on_leaving_area_00_body_entered(body):
	next_stage = 'Stage_0_01'
	Arriving_Area = '00'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, Arriving_Area, false)
		print('Hero Entered to Leaving area 10')

func _on_leaving_area_01_body_entered(body):
	next_stage = 'Stage_0_01'
	Arriving_Area = '01'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, Arriving_Area,  false)
		print('Hero Entered to Leaving area 10')

func _on_leaving_area_02_body_entered(body):
	next_stage = 'World_Map'
	if body.name == 'Hero':
		Aeternus.change_Scene(next_stage, Arriving_Area, false)
		print('Hero Entered to Leaving area 02')

var SCRIPT = {
	
	"Blind as a P I T" : {
		
		'mission_name'	: "Blind as a P I T",
		'participants'	: ['Magonzalo', 'Blind_guy'],
		'accepted'		: false,
		'completed'		: false,
		'target'		: 'Blind guy',
		'requester'		: 'Magonzalo',
		'description'	: "Find a blind man near to THE PIT and bring him back to his friend",
		'reward'		: 'give_item',  ## info # level_up # gold # 
		'item'			: { 
							'name' : 'Special Key',
							'unique_id' : 'single_key_special_Key_given_by_Magonzalo',
							'open_code' : [3030303030],
							'magic' : false,
							'itemClass' : "key",
							'importantItem' : false,
							'group_list' : 'Keys',
							'stackable' : true,
							'stack' : 2,
							'stock' : 2,
							'is_in_belt' : null,
							'type' : 'single key',
							'level' : 1,
							'rarity' : "banal",
							'icon' : [0,3], 
							'icon_inventary' : "res://Assets/Images/Items/Keys/key_special.png",
							'slot' : null,
							'animation' : null,
							#'single_key_special' : {
							},
		'Magonzalo' 	: {
			'name' 			: 'Magonzalo',
			'mission_name' 	: "Blind as a P I T",
			'is_requester'	: true,
			'waiting'		: false,
			'is_target'		: false,
			'dialog'		: {
				'greetings'	: [ "Hola compade, como estas espero que super bien en toda la vida. Haia una vez un compañero que se creía la raja y por hueón vinieron y le lo limpiaron jajajaj",
								"Necesito que alguien me ayude a encontrar a mi amigo.", "Estaráis dispuesto a ayudarme?",
								":options_01:"],
				"options_01" : [
									["Si, por su puesto", ":explanation:"],
									["no, no tengo tiempo",":negate:"],
								],
				"negate"	: ["Bueno no importa, gracias ... por nada",
								"Gallina",
								":_end_:"],
				"explanation" : ["Mi amigo se fue cerca de un sitio llamado \"THE PIT\"", "Visto que el tipo es ciego, temo que pueda harle pasado algo", "Podrías por favor traerlo de vuela?", "Te puedo dar una recompensa", ":options_02:"],
				"options_02" : [
									["Esta bien, no te precupes, yo iré por tu amigo", ":acepte:"],
									["Na me da lata, pejor preguntale a alguien más",":negate_02:"],
								],
				"acepte"	: ["Genial, muchisimas gracias, estaré esperando aquí", ":_end_true_:"],
				"negate_02"	: ["Gallina... ", ":_end_:"],
				'intro'		: [ "Había una vez un perrito que se llamaba calcetín ..",
								"un día salió a la calle ...",
								"y se lo puseron!", ":_end_:"],
				'waiting'	: ["Hey! y mi amigo? done está ? ", "No me ire a casa sin el", ":_end_:"],
				'thanks'	: ["Oh Blind guy !!! Que alegría verte !!!", "Seguro que a ti no te alegra tanto, hem...", "hmmm...", "No importa. Gracias al cielo que estás de vuelta. Estaba muy preocupado", "Gracias ti forastero por encontrar a mi amigo, te estré muy agradecido", "Ten, en recompensa te daré este objeto, una llave.", "hasta prtonto y muchßisimas gracias nuevamente", ":_end_true_end_:"], 
				'say_hi'	: ["Siempre me acordaré de ti por la ayuda que nos diste", ":_end_:"]
			},
		},
		'Blind guy'	:  {
			'name' 			: 'Blind guy',
			'mission_name' 	: "Blind as a P I T",
			'is_target'		: true,
			'is_requester'	: false,
			'after_found'	: 'follow_hero', ## follow_hero # give_item # give_info # level_up # info # gold # open_door #
			'description'	: "Find a blind man near to THE PIT and bring him back to his friend",
			'dialog'		: {
				'greetings'		: [ "Quien está ahí? ...",
									"no logro ver nada...",
									":_end_:"],
				'target_found'	: ["I'm lost ... I can't see ... I can't go back home..,", ":ayuda:"],
				"ayuda"		  	: ["Me puedes ayudar para volver a casa?", ":options_01:"],
				"options_01"	: [
									["No, pudrete aquí solo viejo loco", ":rudo:"],
									["Talvez ... Que me darás a cambio?", ":a_cambio:"],
									["Tu amigo está preocupado por ti, ven, te llevaré con él",":gracias:"],
								],
				"gracias"		: ["Te lo agradezco mucho tu me indicas por donde ir", ":_end_true_:"],
				'a_cambio'		: ["Bueno, la verdad es que no tengo mucho aquí para darte, sólo me quedaba un pan y ya lo comí.",
								"Pero estoy seguro que mi amigo te ofrecerá algo si me ayudas", ":ayuda:"],
				"rudo"			: ["Oh... está bien, no te preocupes. No te suplicaré.", ":_end_:"],
				"say_hi"		: ["Muchas gracias por haberme indicado el camino a casa", ":_end_:"]
			}
		},
	},
	'Im busy' : {
		'mission_name'	: "Im busy",
		'participants'	: ['Walker'] ,
		'accepted'		: false,
		'completed'		: false,
		'target'		: null,
		'requester'		: 'Walker',
		'reward'		: 'give_item',  ## info # level_up # gold # 
		'Walker'		: {
			'name' 			: 'Walker',
			'mission_name' 	: "Im busy",
			'is_target'		: false,
			'is_requester'	: true,
			#'after_found'	: 'follow_hero',
			'dialog'		: {
						'greetings' : ["Sorry man, I'm super busy", ':_end_:']	
			},
		}
	},
	'GREEN pasagers' : { #
		'mission_name'	: "GREEN pasagers",
		'participants'	: ['Green_square'] ,
		'accepted'		: false,
		'completed'		: false,
		'target'		: null,
		'requester'		: 'Green Square',
		'Green Square'	: {
			'name'			: 'Green Square',
			'mission_name' 	: "GREEN pasagers",
			'is_target'		: false,
			'is_requester'	: true,
			'dialog'		: {
						'greetings'	: ["I am a green square", "What do you want from me?", "::_end_true_end_::"],
						"say_hi"	: ["Muchas gracias por haberme dejado tranquilo", ":_end_:"]
			}
		},
	},
	'Merchandising' : { #
		'mission_name'	: "Merchandising",
		'participants'	: ['Merchant'] ,
		'accepted'		: false,
		'completed'		: false,
		'target'		: null,
		'requester'		: 'Merchant',
		'Merchant'	: {
			'name'			: 'Merchant',
			'mission_name' 	: "Merchandising",
			'is_target'		: false,
			'is_requester'	: true,
			'dialog'		: {
						'greetings'	: [	"GREETINGS MY GOOD FRINEND",
										"I have excelent products that you would love to see",
										"And adquire, I'm sure of that ",
										":options_01:"
										],
						'options_01': [	
											["Oh, yeah, sure, I would like to see waht you have to offer", ":_end_open_shop_:"], 
											["do you have any information that you can provide me?", ":maybe:"],
											["No, thank. I was just waching", ":no_problem:"]
										],
						"maybe"		: 	["Mmmmm, maybe ...", "How much do you have for a little information?", ":_end_:"],
						"no_problem" : ["That's okay, if you need something just let me know", ":_end_:"],
						}
		}
	}
}
