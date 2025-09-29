extends Node2D
class_name LayerLoader

func load_elements() -> void:
	pass


func load_nodes_to(layer: Node) -> void:
	for child in get_children():
		Layer.add_element(child, layer)
