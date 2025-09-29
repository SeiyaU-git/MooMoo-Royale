extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var ui_stuff: Control
@export var name_label: Label
@export var text_box: LineEdit
@export var chat: PanelContainer

var owner_id: int
var player_name: String
var is_authority: bool:
	get: return (not NetworkHandler.is_server) and (owner_id == ClientNetworkGlobals.id) 

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_transformation.connect(server_handle_player_transformation)
	ClientNetworkGlobals.handle_player_transformation.connect(client_handle_player_transformation)
	
	ClientNetworkGlobals.handle_player_chat.connect(client_player_chat)
	#ServerNetworkGlobals.handle_player_chat.connect(player_chat)
	name_label.text = str(player_name)
	
	if is_authority:
		modulate = Color(1.0, 0.894, 1.0, 1.0)
	
	else:
		modulate = Color(1.0, 0.894, 0.882, 1.0)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_transformation.disconnect(server_handle_player_transformation)
	ClientNetworkGlobals.handle_player_transformation.disconnect(client_handle_player_transformation)
	
	ClientNetworkGlobals.handle_player_chat.disconnect(client_player_chat)
	#ServerNetworkGlobals.handle_player_chat.disconnect(player_chat)

func _process(delta: float) -> void:
	
	if is_authority: 
		client_process(delta)
	
	ui_stuff.rotation = -global_rotation

func client_process(delta: float) -> void:
	global_position += Input.get_vector("left", "right", "up", "down") * delta * 400
	
	if not animation_player.current_animation == "attack":
		look_at(get_global_mouse_position())
	
	var packet: PlayerTransformation = PlayerTransformation.create(owner_id, global_position, global_rotation)
	packet.send(NetworkHandler.server_peer)
	
	if Input.is_action_pressed("attack"):
		animation_player.play("attack")
	
	if Input.is_action_just_pressed("chat"):
		text_box.use()
	
	Layer.camera.global_position = global_position

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

func client_player_chat(player_chat):
	print(str("chat data recived", player_chat.id, player_chat.text))
	if player_chat.id == owner_id:
		chat.show_message(player_chat.text)
