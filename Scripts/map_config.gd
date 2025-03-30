extends Node
class_name map_config

var next_stage
var Start_position
var New_start_position

@export var Stage_name : String = ''
@export var Stage_level : int = 1
#@export var PNJ_in_Map : Array = []

var Arriving_Area = null

var PNJ_group = []

func history_progressions_consecuences() :
	print('history_progressions_consecuences')
	var to_remove
	if Stage_name != '' :
		for pnj in PNJ_group :
			if pnj.Mission_name != '' :
				if hero_data.PROGRESS.Missions.has(pnj.Mission_name) :
					if hero_data.PROGRESS.Missions[pnj.Mission_name].completed :
						if pnj.After_Mission.Position == Vector2(-1,-1) :
							PNJ_group.erase(pnj)
							pnj.queue_free()
						elif pnj.After_Mission.Position != Vector2(0,0) :
							pnj.position = pnj.After_Mission.Position
						if  pnj.After_Mission.State != '' : 
							pnj.current_state = pnj.pnj_states[pnj.After_Mission.State]
			else :
				print('no tiene misión')
				
	if to_remove != null :
		to_remove.queue_free()
	print('END - history_progressions_consecuences')
