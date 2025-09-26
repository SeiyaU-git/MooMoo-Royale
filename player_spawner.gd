extends Node

const PLAYER = preload("res://player/player.tscn")

func _ready() -> void:
	NetworkHandler.on_peer_connected.connect(spawn_player)
	ClientNetworkGlobals.handle_local_id_assignment.connect(spawn_player)
	ClientNetworkGlobals.handle_remote_id_assignment.connect(spawn_player)

func spawn_player(id: int) -> void:
	var player = PLAYER.instantiate()
	player.owner_id = id
	player.name = str("Unknown id: ", id) # CHANGE LATER
	
	call_deferred("add_child", player)
	print("PLAYER SPAWNED")
