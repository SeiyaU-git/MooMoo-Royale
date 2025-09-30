extends Node

const PLAYER = preload("res://player/player.tscn")
const BUSH_SCENE_LOADER = preload("res://bush_scene_loader.tscn")

var player_names: Dictionary

var currently_alive_ids: Array

var ids_spawned: Array

func _enter_tree() -> void:
	ServerNetworkGlobals.on_player_spawned.connect(spawn_player)
	#ClientNetworkGlobals.handle_local_id_assignment.connect(spawn_player)
	#-->#ClientNetworkGlobals.handle_remote_id_assignment.connect(spawn_player)
	ClientNetworkGlobals.handle_player_creation.connect(spawn_player)
	
	ServerNetworkGlobals.on_player_deleted.connect(delete_player)
	ClientNetworkGlobals.handle_player_deletion.connect(delete_player)
	Layer.arena.add_child(BUSH_SCENE_LOADER.instantiate())
	

func spawn_player(id: int, player_name: String) -> void:
	
	if id in ids_spawned:
		print("player skipped", id)
		return
		

	ids_spawned.append(id)
	var player = PLAYER.instantiate()
	player.owner_id = id
	player.player_name = str(player_name) # CHANGE LATER
	
	Layer.call_deferred("add_element", player, Layer.entity)
	print("PLAYER SPAWNED")
	if Global.game_ui:
		Global.game_ui.leader_bored.text += str("\n", player.owner_id, ": ", player.player_name)

func delete_player(peer_id: int) -> void:
	ids_spawned.erase(peer_id)
	for child in get_children():
		if child is Player and not child.owner_id in ids_spawned:
			child.queue_free()
