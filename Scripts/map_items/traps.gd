#@tool
extends Area2D

enum TRAPS {SPIKE, GAS, WASH, PIT}
@export var Trap_type : TRAPS

#var Current_stage = Aeternus.Current_stage ## Current stage name or ID
var Stage_level # =  Aeternus.Stage_level ## Difficulty Level 

var Traps_list = [ 'Spike', 'Gas', 'Wash', 'Pit', ]

var Traps = {
	'Spike' : {
		'name' : 'Spike',
		'Frame' : [4,2],
		'Animate' : true,
		'Activate_animation' : true,
		'Activate_anim' : '',
		'Frames' : [],
		'Solid' : true,
		'Shape' : '',
		'Size' : [4,5],
		'Damage' : [1, 6], ## Maibe implement damage * difficulty level
		'Duraton' : 1,
	},
	'Gas' : {
		'name' : 'Gas',
		'Frame' : [4,3],
		'Animate' : false,
		'Activate_animation' : true,
		'Activate_anim' : '',
		'Frames' : [],
		'Solid' : true,
		'Shape' : '',
		'Size' : [4,5],
		'Damage' : [1, 4], ## Maibe implement damage * difficulty level
		'Duraton' : 10,
	},
	'Wash' : {
		'name' : 'Wash',
		'Frame' : [4,5],
		'Animate' : true,
		'Activate_animation' : false,
		'Activate_anim' : '',
		'Frames' : [[4,5], [4,6], [4,7], [4,8]],
		'Solid' : true,
		'Shape' : '',
		'Size' : [4,5],
		'Damage' : [1, 10], ## Maibe implement damage * difficulty level
		'Duraton' : 10000,
	}, 
	'Pit' : {
		'name' : 'Pit',
		'Frame' : [6,4],
		'Animate' : false,
		'Activate_animation' : false,
		'Activate_anim' : '',
		'Frames' : [],
		'Solid' : true,
		'Shape' : '',
		'Size' : [4,5],
		'Damage' : [1, 6], ## Maibe implement damage * difficulty level
		'Duraton' : 1,
	}, 
}

var Trap
var Damage 
var Hero = false
@onready var timer = $Timer
@onready var solid_area = $StaticBody2D/Trap_area3
var timer_time = 0.8
var into = false
var victim

func _ready():
	Stage_level =  Aeternus.Stage_level
	Trap = Traps[Traps_list[Trap_type]]
	$Sprite2D.set_frame_coords(Vector2i(Trap.Frame[0], Trap.Frame[1]))
	if Trap.Animate :
		$Amination.play(Traps_list[Trap_type])

func _process(delta):
	#if Engine.is_editor_hint():
	pass
		#$Sprite2D.set_frame_coords(Vector2i(Trap.Frame[0], Trap.Frame[1]))
		
func damage_trap(victime):
	victime.hit(Aeternus.dice_through(Trap.Damage[0], Trap.Damage[1]))
	if Trap.Activate_animation :
		#$Amination.play(Trap.Activate_anim)
		# IF TRAP IS ACTIVATED, THEN AN ANIMATION ; EXAMPLE, GAS OR SPIKE 
		pass
	

func _on_timer_timeout():
	damage_trap(victim)

func _on_danger_area_body_entered(body):
	victim = body
	if body.name == 'Hero':
		if body.current_state == 2 : # Jumping
			return
		into = true
		Hero = body
		damage_trap(body)
		if Trap.name == 'Wash':
			timer.start(timer_time)
	elif body.is_in_group('Enemies') :
		body.random_walk()
		#damage_trap(body)

func _on_danger_area_body_exited(body):
	if body.name == 'Hero':
		into = false
		timer.stop()

func _on_solid_area_body_entered(body):
	if body.name == 'Hero':
		solid_area.set_deferred('disabled', true )
func _on_solid_area_body_exited(body):
	if body.name == 'Hero':
		solid_area.set_deferred('disabled', false)





