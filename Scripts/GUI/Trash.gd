extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func delete_item(item):
		 # Item deleted
	item.queue_free()
