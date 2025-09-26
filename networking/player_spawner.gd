extends Node

const PLAYER = preload("res://player/player.tscn")

var player_names: Dictionary

var currently_alive_ids: Array

var ids_spawned: Array

func _ready() -> void:
	ServerNetworkGlobals.on_peer_joined.connect(spawn_player)
	#ClientNetworkGlobals.handle_local_id_assignment.connect(spawn_player)
	#-->#ClientNetworkGlobals.handle_remote_id_assignment.connect(spawn_player)
	ClientNetworkGlobals.handle_player_creation.connect(spawn_player)
	

func spawn_player(id: int, player_name: String) -> void:
	
	if id in ids_spawned:
		print("player skipped", id)
		return
		

	ids_spawned.append(id)
	var player = PLAYER.instantiate()
	player.owner_id = id
	player.player_name = str(player_name, id) # CHANGE LATER
	
	call_deferred("add_child", player)
	print("PLAYER SPAWNED")
