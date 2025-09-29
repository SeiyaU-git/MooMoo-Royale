extends Area2D
class_name MonitoringArea

signal area_detected(area: Area2D)

@export var detect_areas: bool = false
var _processed_areas := {}

func _ready() -> void:
	# Connect this Area2D's built-in signal to our handler
	area_entered.connect(_on_area_entered)
	# Optional: connect our custom signal somewhere
	area_detected.connect(on_area_detected)

func enable_monitoring() -> void:
	monitoring = true
	visible = true
	if detect_areas:
		for area in get_overlapping_areas():
			_process_area(area)

func disable_monitoring() -> void:
	monitoring = false
	visible = false
	_processed_areas.clear()

func _on_area_entered(area: Area2D) -> void:
	_process_area(area)

func _process_area(area: Area2D) -> void:
	if area in _processed_areas:
		return
	_processed_areas[area] = true
	area_detected.emit(area)  # emit the custom signal

func on_area_detected(area: Area2D) -> void:
	pass
