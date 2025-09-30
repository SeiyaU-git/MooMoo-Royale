extends Area2D

func receive_hit(damage_data: Dictionary = {}, is_authority: bool = false):
	get_parent().health -= damage_data.damage
