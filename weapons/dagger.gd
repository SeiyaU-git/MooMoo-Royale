@tool
extends PlayerWeapon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if master:
		global_position = get_hand_pos(hand_r)
		global_rotation = hand_r.global_rotation
