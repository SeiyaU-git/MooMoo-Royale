extends CharacterBody2D

var owner_id: int

var is_authority: bool:
	get: return (not NetworkHandler.is_server) and (owner_id == ClientNetworkGlobals.id) 

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_transformation.connect(server_handle_player_transformation)
	ClientNetworkGlobals.handle_player_transformation.connect(client_handle_player_transformation)
	$NameLabel.text = name
	$IdLabel.text = str(owner_id)
	
	if is_authority:
		modulate = Color(0.518, 0.553, 1.0, 1.0)
	
	else:
		modulate = Color(1.0, 0.553, 0.569, 1.0)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_transformation.disconnect(server_handle_player_transformation)
	ClientNetworkGlobals.handle_player_transformation.disconnect(client_handle_player_transformation)


func _process(delta: float) -> void:
	if not is_authority: 
		return
	
	global_position += Input.get_vector("left", "right", "up", "down") * delta * 400
	look_at(get_global_mouse_position())
	
	var packet: PlayerTransformation = PlayerTransformation.create(owner_id, global_position, global_rotation)
	packet.send(NetworkHandler.server_peer)

func server_handle_player_transformation(peer_id: int, player_transformation: PlayerTransformation) -> void:
	if owner_id != peer_id:
		return
	
	global_position = player_transformation.position
	global_rotation = player_transformation.rotation
	
	PlayerTransformation.create(owner_id, global_position, global_rotation).broadcast(NetworkHandler.connection)

func client_handle_player_transformation(player_transformation: PlayerTransformation) -> void:
	if is_authority:
		return
	
	if owner_id != player_transformation.id:
		return
	
	global_position = player_transformation.position
	global_rotation = player_transformation.rotation
