extends Area2D
class_name MaterialArea

@onready var sprite_2d: Sprite2D = $"../Sprite2D"

func _process(delta: float) -> void:
	# Smoothly move the sprite toward the origin
	sprite_2d.position = sprite_2d.position.lerp(Vector2.ZERO, 0.5)

func receive_hit(damage_data: Dictionary = {}, is_authority: bool = false):
	# Shake the sprite in a random direction
	sprite_2d.position = Vector2.RIGHT.rotated(randf() * TAU) * 20
	if is_authority:
		Global.player_manager.wood += 1
		Global.player_manager.xp += 1
