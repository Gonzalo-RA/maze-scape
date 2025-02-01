extends TextureRect

@onready var Item_Info = get_parent().get_node('Item_Info')
@onready var Item_Name = get_parent().get_node('Item_Info/Item_Name')
@onready var Rarity = get_parent().get_node('Item_Info/Rarity')
@onready var Attribute_1 = get_parent().get_node('Item_Info/Attribute_1')
#@onready var Item_Info = get_parent().get_node('Item_Info')

var in_belt = false

var it_name
var it_rarity
var it_class
var affectation
var dices
var affectatio_text = ''
var text_to_display

func _ready():
	
	it_name = BackPack.Back_Pack[self.name].name
	it_class = BackPack.Back_Pack[self.name].itemClass
	it_rarity = BackPack.Back_Pack[self.name].rarity if it_class != 'potion' else ''	
	dices = BackPack.Back_Pack[self.name].dices

	if  it_class != 'potion' :
		affectation = BackPack.Back_Pack[self.name].affectations ## ARRAY #if it_class == 'potion' else ''
		for aff in affectation :
			affectatio_text += aff + ' : ' + str(BackPack.Back_Pack[self.name].affectations[aff]) + '\n'
	
	text_to_display = str(it_name) + "\n--\n" + str(it_rarity) 
	
	if  it_class != 'potion' :
		text_to_display = text_to_display + "\n\n" + str(affectatio_text)
		#Attribute_1.set_text(affectatio_text)
		
func _on_mouse_entered():
	Item_Name.set_text(text_to_display)
	#Rarity.set_text(it_rarity)
	#if  it_class != 'potion' :
		#Attribute_1.set_text(affectatio_text)
		
func _on_mouse_exited():
	Item_Name.set_text('')
	Rarity.set_text('')
	Attribute_1.set_text('')
