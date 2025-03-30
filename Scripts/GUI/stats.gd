extends Control

@onready var Name = $Personal_Info/Name
@onready var Level = $Personal_Info/Level/value
@onready var XP = $Personal_Info/Experience/value

@onready var Health = $Personal_Info/Health/value
@onready var Mana = $Personal_Info/Mana/value
@onready var Energy = $Personal_Info/Energy/value

@onready var Add_points_lavel = $Stats_infos/Add_points
@onready var Confirm_button = $Stats_infos/Confirm

@onready var Strength = $Stats_infos/Strength/value
@onready var Strength_modif = $Stats_infos/Strength/modif
@onready var Strength_item_modif = $Stats_infos/Strength/item_mod
var Strength_temporal_modif = 0 #hero_data.Strength
@onready var Constitution = $Stats_infos/Constitution/value
@onready var Constitution_modif = $Stats_infos/Constitution/modif
@onready var Constitution_item_modif = $Stats_infos/Constitution/item_mod
var Constitution_temporal_modif = 0 #hero_data.Constitution
@onready var Dexterity = $Stats_infos/Dexterity/value
@onready var Dexterity_modif = $Stats_infos/Dexterity/modif
@onready var Dexterity_item_modif = $Stats_infos/Dexterity/item_mod
var Dexterity_temporal_modif = 0 #hero_data.Dexterity
@onready var Intelligence = $Stats_infos/Intelligence/value
@onready var Intelligence_modif = $Stats_infos/Intelligence/modif
@onready var Intelligence_item_modif = $Stats_infos/Intelligence/item_mod
var Intelligence_temporal_modif = 0 #hero_data.Intelligence
@onready var Wisdom = $Stats_infos/Wisdom/value
@onready var Wisdom_modif = $Stats_infos/Wisdom/modif
@onready var Wisdom_item_modif = $Stats_infos/Wisdom/item_mod
var Wisdom_temporal_modif = 0 #hero_data.Wisdom
@onready var Charisma = $Stats_infos/Charisma/value
@onready var Charisma_modif = $Stats_infos/Charisma/modif
@onready var Charisma_item_modif = $Stats_infos/Charisma/item_mod
var Charisma_temporal_modif = 0 #hero_data.Charisma

@onready var Attack = $Combat_info/Attack/value
@onready var Damage = $Combat_info/Damage/value
@onready var Speed = $Combat_info/Speed/value
@onready var Armor = $Combat_info/Armor/value
@onready var Absorption = $Combat_info/Absorption/value

@onready var Temporal_Points_to_distribute = hero_data.Points_to_distribute

var stats_on = false
#var LEVEL_UP = false


func _ready():
	Confirm_button.disabled = true
	Confirm_button.hide()
	


func _process(delta):
	if stats_on :
		Write_info()
		show()
		set_offset(1, -93 )
	elif !stats_on	:
		set_offset(1, 124)
		
	if hero_data.TO_LEVEL_UP :
		all_on()	

func _on_stats_button_pressed():
	if !stats_on :
		stats_on = true
	elif stats_on :
		stats_on = false

func Write_info() :
	Name.set_text(hero_data.hero_name)
	Level.set_text(str(hero_data.Level))
	XP.set_text(str(hero_data.XP) + ' / ' + str(Aeternus.XP_LEVELS[str(hero_data.Level + 1)]))
	Health.set_text( str(floor(hero_data.current_health)) + ' / ' +  str(hero_data.max_health) )
	Mana.set_text( str(floor(hero_data.Mana)) + ' / ' +  str(hero_data.Mana) )
	Energy.set_text( str(floor(hero_data.current_energy)) + ' / ' +  str(hero_data.max_energy) )
	
	Add_points_lavel.set_text(str(Temporal_Points_to_distribute))
	if Temporal_Points_to_distribute <= 0 or Confirm_button.disabled :
		Add_points_lavel.set("theme_override_colors/font_color", Color(0.333,0.333,0.333,1.0)) 
	else :
		Add_points_lavel.set("theme_override_colors/font_color", Color(0.333,0.333,1.0,1.0))  #theme_override_colors/font_color 
	
	Strength.set_text(str(hero_data.Strength + Strength_temporal_modif ))
	Strength_modif.set_text(str(hero_data.Strength_modificator )) ## - hero_data.chart_of_equipment_modificators["Strength"] 
	Strength_item_modif.set_text(str(hero_data.chart_of_equipment_modificators["Strength"]))
	
	Constitution.set_text(str(hero_data.Constitution + Constitution_temporal_modif ))
	Constitution_modif.set_text(str(hero_data.Constitution_modificator )) ## - hero_data.chart_of_equipment_modificators["Constitution"] 
	Constitution_item_modif.set_text(str(hero_data.chart_of_equipment_modificators["Constitution"]))
	
	Dexterity.set_text(str(hero_data.Dexterity + Dexterity_temporal_modif ))
	Dexterity_modif.set_text(str(hero_data.Dexterity_modificator )) ## - hero_data.chart_of_equipment_modificators["Dexterity"] 
	Dexterity_item_modif.set_text(str(hero_data.chart_of_equipment_modificators["Dexterity"]))
	
	Intelligence.set_text(str(hero_data.Intelligence + Intelligence_temporal_modif ))
	Intelligence_modif.set_text(str(hero_data.Intelligence_modificator )) ## - hero_data.chart_of_equipment_modificators["Intelligence"] 
	Intelligence_item_modif.set_text(str(hero_data.chart_of_equipment_modificators["Intelligence"]))
	
	Wisdom.set_text(str(hero_data.Wisdom + Wisdom_temporal_modif ))
	Wisdom_modif.set_text(str(hero_data.Wisdom_modificator )) ## - hero_data.chart_of_equipment_modificators["Wisdom"] 
	Wisdom_item_modif.set_text(str(hero_data.chart_of_equipment_modificators["Wisdom"]))
	
	Charisma.set_text(str(hero_data.Charisma + Charisma_temporal_modif ))
	Charisma_modif.set_text(str(hero_data.Charisma_modificator )) ## - hero_data.chart_of_equipment_modificators["Charisma"] 
	Charisma_item_modif.set_text(str(hero_data.chart_of_equipment_modificators["Charisma"]))

	Attack.set_text(str(hero_data.Attack))
	Damage.set_text(str(hero_data.Weapons[hero_data.equiped_weapon[0]].dices[0] + hero_data.Damage_modificator ) + ' - ' + str(hero_data.Weapons[hero_data.equiped_weapon[0]].dices[1] + hero_data.Damage_modificator ))
	Speed.set_text(str(hero_data.Speed))
	Armor.set_text(str(hero_data.Armor))
	Absorption.set_text(str(hero_data.Armor_absorption))

func _on_add_strength_pressed():
	if Temporal_Points_to_distribute > 0 :
		Strength_temporal_modif += 1
		Temporal_Points_to_distribute -= 1 

func _on_subs_strength_pressed():
	if Temporal_Points_to_distribute < hero_data.Points_to_distribute :
		Strength_temporal_modif -= 1
		Temporal_Points_to_distribute += 1

func _on_add_constitution_pressed():
	if Temporal_Points_to_distribute > 0 :
		Constitution_temporal_modif += 1
		Temporal_Points_to_distribute -= 1 

func _on_subs_constitution_pressed():
	if Temporal_Points_to_distribute < hero_data.Points_to_distribute :
		Constitution_temporal_modif -= 1
		Temporal_Points_to_distribute += 1

func _on_add_dexterity_pressed():
	if Temporal_Points_to_distribute > 0 :
		Dexterity_temporal_modif += 1
		Temporal_Points_to_distribute -= 1 

func _on_subs_dexterity_pressed():
	if Temporal_Points_to_distribute < hero_data.Points_to_distribute :
		Dexterity_temporal_modif -= 1
		Temporal_Points_to_distribute += 1
	
func _on_add_inteligence_pressed():
	if Temporal_Points_to_distribute > 0 :
		Intelligence_temporal_modif += 1
		Temporal_Points_to_distribute -= 1 

func _on_subs_inteligence_pressed():
	if Temporal_Points_to_distribute < hero_data.Points_to_distribute :
		Intelligence_temporal_modif -= 1
		Temporal_Points_to_distribute += 1

func _on_add_wisdom_pressed():
	if Temporal_Points_to_distribute > 0 :
		Wisdom_temporal_modif += 1
		Temporal_Points_to_distribute -= 1 

func _on_subs_wisdom_pressed():
	if Temporal_Points_to_distribute < hero_data.Points_to_distribute :
		Wisdom_temporal_modif -= 1
		Temporal_Points_to_distribute += 1

func _on_add_charisma_pressed():
	if Temporal_Points_to_distribute > 0 :
		Charisma_temporal_modif += 1
		Temporal_Points_to_distribute -= 1 

func _on_subs_charisma_pressed():
	if Temporal_Points_to_distribute < hero_data.Points_to_distribute :
		Charisma_temporal_modif -= 1
		Temporal_Points_to_distribute += 1

func all_on() :
	Temporal_Points_to_distribute = hero_data.Points_to_distribute
	Confirm_button.disabled = false
	Confirm_button.show()
	$Stats_infos/Add_strength.disabled = false
	$Stats_infos/Add_constitution.disabled = false
	$Stats_infos/Add_dexterity.disabled = false
	$Stats_infos/Add_inteligence.disabled = false
	$Stats_infos/Add_wisdom.disabled = false
	$Stats_infos/Add_charisma.disabled = false
	$Stats_infos/Subs_strength.disabled = false
	$Stats_infos/Subs_constitution.disabled = false
	$Stats_infos/Subs_dexterity.disabled = false
	$Stats_infos/Subs_inteligence.disabled = false
	$Stats_infos/Subs_wisdom.disabled = false
	$Stats_infos/Subs_charisma.disabled = false
	hero_data.TO_LEVEL_UP = false

func _on_confirm_pressed():
	hero_data.Strength += Strength_temporal_modif 
	hero_data.Constitution += Constitution_temporal_modif 
	hero_data.Dexterity += Dexterity_temporal_modif 
	hero_data.Intelligence += Intelligence_temporal_modif 
	hero_data.Wisdom += Wisdom_temporal_modif 
	hero_data.Charisma += Charisma_temporal_modif 
	
	Strength_temporal_modif = 0
	Constitution_temporal_modif = 0
	Dexterity_temporal_modif = 0
	Intelligence_temporal_modif = 0
	Wisdom_temporal_modif = 0
	Charisma_temporal_modif = 0
	
	hero_data.update_stats()
	
	Confirm_button.disabled = true
	Confirm_button.hide()
	$Stats_infos/Add_strength.disabled = true
	$Stats_infos/Add_constitution.disabled = true
	$Stats_infos/Add_dexterity.disabled = true
	$Stats_infos/Add_inteligence.disabled = true
	$Stats_infos/Add_wisdom.disabled = true
	$Stats_infos/Add_charisma.disabled = true
	$Stats_infos/Subs_strength.disabled = true
	$Stats_infos/Subs_constitution.disabled = true
	$Stats_infos/Subs_dexterity.disabled = true
	$Stats_infos/Subs_inteligence.disabled = true
	$Stats_infos/Subs_wisdom.disabled = true
	$Stats_infos/Subs_charisma.disabled = true
