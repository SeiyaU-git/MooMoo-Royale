extends PanelContainer

@onready var timer: Timer = $Timer
@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	clear()

func show_message(message: String):
	show()
	label.text = message
	timer.start()


func _on_timer_timeout() -> void:
	clear()

func clear() -> void:
	hide()
	label.text = ""
