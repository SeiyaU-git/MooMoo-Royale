extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $Body/AnimationPlayer

@export var ui_stuff: Control
@export var name_label: Label
@export var text_box: LineEdit
@export var chat: PanelContainer

@export var health_bar: ProgressBar 

var health: float = 100

var owner_id: int
var player_name: String
var is_authority: bool:
	get: return (not NetworkHandler.is_server) and (owner_id == ClientNetworkGlobals.id) 

var is_xlock := false
var is_auto_attack := false



func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_transformation.connect(server_handle_player_transformation)
	ClientNetworkGlobals.handle_player_transformation.connect(client_handle_player_transformation)
	
	ClientNetworkGlobals.handle_player_chat.connect(client_player_chat)
	#ServerNetworkGlobals.handle_player_chat.connect(player_chat)
	ClientNetworkGlobals.handle_player_attack.connect(client_player_attack)
	
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
		
	health_bar.value = health
	ui_stuff.rotation = -global_rotation

func _physics_process(delta: float) -> void:
	if is_authority: 
		client_physics(delta)

func client_process(delta: float) -> void:
	if Input.is_action_just_pressed("lock_direction"):
		is_xlock = ! is_xlock
		if is_xlock:
			chat.show_message("Rotation locked with [X]")
		else:
			chat.show_message("Rotation Unlocked")
	
	if Input.is_action_just_pressed("auto attack"):
		is_auto_attack = ! is_auto_attack
		if is_auto_attack:
			chat.show_message("Auto attack enabled with [E]")
		else:
			chat.show_message("Auto attack disabled")
	
	if not (animation_player.current_animation == "attack" or is_xlock):
		look_at(get_global_mouse_position())
	
	if (Input.is_action_pressed("attack") or is_auto_attack) and animation_player.current_animation != "attack":
		PlayerAttackPacket.create(owner_id).send(NetworkHandler.server_peer)
	
	if Input.is_action_just_pressed("chat"):
		text_box.use()

func client_physics(delta: float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down").normalized()
	var motion = input_vector * 400 * delta

	var collision = move_and_collide(motion)
	if collision:
		# slide along the collider normal
		motion = motion.slide(collision.get_normal())
		move_and_collide(motion)
	
	var packet: PlayerTransformation = PlayerTransformation.create(owner_id, global_position, global_rotation)
	packet.send(NetworkHandler.server_peer)
	
	Layer.camera.global_position = lerp(Layer.camera.global_position, global_position, 0.1)

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

func client_player_attack(player_attack: PlayerAttackPacket):
	if owner_id == player_attack.id:
		animation_player.play("Slash1")

func client_player_chat(player_chat):
	print(str("chat data recived", player_chat.id, player_chat.text))
	if player_chat.id == owner_id:
		chat.show_message(player_chat.text)
