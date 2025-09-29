extends Node
class_name SceneLoader

func _ready() -> void:
	print("loaded scene")
	for child in get_children():
		if child is LayerLoader:
			child.load_elements()
	
	
	#call_deferred("queue_free")
