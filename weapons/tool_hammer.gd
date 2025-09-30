@tool
extends Node2D

@onready var attack_area: AttackArea = $AttackArea

@onready var hand_l: Sprite2D
@onready var hand_r: Sprite2D

var master: Node2D

func _enter_tree() -> void:
	if get_parent():
		master = get_parent()
		
	if master:
		hand_l = master.handl
		hand_r = master.handr
	
	if not master:
		return
	
	master.animation_player.start_dealing_damage.connect(start_dealing_damage)
	master.animation_player.end_dealing_damage.connect(end_dealing_damage)

func _exit_tree() -> void:
	if not master:
		return
	
	master.animation_player.start_dealing_damage.connect()
	master.animation_player.end_dealing_damage.connect()

func get_hand_pos(node: Sprite2D) -> Vector2:
	if node and node.get_child_count() > 0:
		return node.get_child(0).global_position
	return node.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if master:
		global_position = get_hand_pos(hand_l)
		global_rotation = (get_hand_pos(hand_r) - get_hand_pos(hand_l)).angle()
func start_dealing_damage() -> void:
	attack_area.enable_monitoring()

func end_dealing_damage() -> void:
	attack_area.disable_monitoring()
