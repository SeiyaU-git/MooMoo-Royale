extends Node

var arena: Node2D
var entity: Node2D
var ui: CanvasLayer

var root: Node

var camera: Camera2D

func add_element(node_2d: Node2D, layer: Node2D) -> Node2D:
	layer.add_child(node_2d)
	return node_2d

func load_ui(ui_layer: PackedScene, delete: bool = true) -> Control:
	if delete:
		for child in ui.get_children():
			child.queue_free()
	
	var _node = ui_layer.instantiate()
	ui.add_child(_node)
	return _node

func clear(layer: Node2D) -> void:
	for child in layer.get_children():
		child.queue_free()

func get_elements(layer: Node2D) -> Array[Node]:
	return layer.get_children()
