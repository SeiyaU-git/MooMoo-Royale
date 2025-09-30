extends MonitoringArea
class_name AttackArea

const EFFECT_PLAYER = preload("uid://0ngufuh5fgsg")

var owner_id: int
# Animals use id of 400
# Bosses use if of 600

var team_id: int

var damage: float


func on_area_detected(area: Area2D) -> void:
	var damage_data := {}
	damage_data.damage = damage
	if area is MaterialArea:
		area.receive_hit(damage_data, true)
	else:
		area.receive_hit(damage_data, true)
	
	var _inst = EFFECT_PLAYER.instantiate()
	Layer.arena.add_child(_inst)
	_inst.global_position = global_position + Vector2.RIGHT.rotated(randf() * TAU) * 10
	
