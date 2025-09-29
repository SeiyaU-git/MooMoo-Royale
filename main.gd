extends Node

const BUSH = preload("uid://cccds5jrulqvt")

const START_UI = preload("uid://cj3ki0ann1avg")
const PLAYER_SPAWNER = preload("uid://pfwya8vngey")

func _ready() -> void:
	Layer.arena = $ArenaLayer
	Layer.entity = $EntityLayer
	Layer.ui = $UILayer
	
	Layer.root = self
	
	Layer.load_ui(START_UI)
	
	add_child(PLAYER_SPAWNER.instantiate())
	
	Layer.camera = $Camera2D
