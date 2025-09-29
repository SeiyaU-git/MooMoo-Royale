extends LayerLoader
class_name ArenaLayerLoader

func load_elements() -> void:
	print("added elements to arena")
	#Layer.add_element(self, Layer.arena)
	load_nodes_to(Layer.arena)
	#queue_free()
