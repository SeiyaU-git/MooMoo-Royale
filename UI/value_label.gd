@tool
extends Label
class_name ValueLabel

@export var text_label: String:
	set(value):
		_text = value
		_update_label()
	get:
		return _text
var _text: String

@export var number: int:
	set(value):
		_number = value
		_update_label()
	get:
		return _number
var _number: int

@export var unit: String:
	set(value):
		_unit = value
		_update_label()
	get:
		return _unit
var _unit: String

func _ready() -> void:
	_update_label()

func _update_label() -> void:
	text = str(_text, ": ", _number, " ", _unit) 
