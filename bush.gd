extends Area2D
class_name MaterialArea
const EFFECT_PLAYER = preload("uid://0ngufuh5fgsg")

@onready var sprite_2d: Sprite2D = $"../Sprite2D"

var stun_frames: int = 0

func _process(delta: float) -> void:
	# Smoothly move the sprite toward the origin
	
	stun_frames -= 1
	if stun_frames <= 0:
		sprite_2d.position = sprite_2d.position.lerp(Vector2.ZERO, 0.3)

func receive_hit(damage_data: Dictionary = {}, is_authority: bool = false):
	# Shake the sprite in a random direction
	sprite_2d.position = Vector2.RIGHT.rotated(randf() * TAU) * 20
	stun_frames = 5
	
	var _inst = EFFECT_PLAYER.instantiate()
	get_parent().add_child(_inst)
	_inst.position = Vector2.RIGHT.rotated(randf() * TAU) * 100
	
	if is_authority:
		Global.player_manager.wood += 1
		Global.player_manager.xp += 1
