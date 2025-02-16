#@tool
extends Node2D
class_name teletransporter

enum USER { HERO, All }
var Users = ['Hero', 'All']

@export var Portal_number = 100
@export var Usage : USER
@onready var Brothers = get_parent().get_children()
@onready var User = Users[Usage]

var BRO
var BRO_position
var available = true

func _ready():
	for bro in Brothers :
		if bro.name.contains('Teletransporter') and bro != self:
			if bro.Portal_number == Portal_number:
				BRO = bro
				BRO_position = bro.position
				BRO_position.y = BRO_position.y - 5

func _on_space_a_body_entered(body):
	if BRO :
		if User == BRO.User and BRO.available:
			if User == 'Hero' and body.name == 'Hero' :
				Teletransporter(body)
			elif User == 'All' and body.is_in_group('PNJ') or body.name == 'Hero' :
				Teletransporter(body)

func Teletransporter(body):
		BRO.available = false
		available = false
		body.position = BRO_position		

func _on_space_a_body_exited(body):
	if BRO and BRO_position :
		BRO.available = true
		available = true
