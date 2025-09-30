extends AnimationPlayer
class_name AttackAnimation

signal start_dealing_damage
signal end_dealing_damage

var _dealing_damage: bool
@export var dealting_damage: bool = false:
	set(value):
		_dealing_damage = value
		
		if _dealing_damage:
			start_dealing_damage.emit()
		else:
			end_dealing_damage.emit()
	get:
		return _dealing_damage
