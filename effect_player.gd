extends Node2D

func _ready() -> void:
	$Timer.timeout.connect(on_timeout)
	call_deferred("play_effect")

func play_effect() -> void:
	$Timer.start()
	$HitEffect.emitting = true

func on_timeout():
	queue_free()
