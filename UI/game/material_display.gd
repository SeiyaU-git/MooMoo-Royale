@tool
extends PanelContainer
class_name MaterialDisplay

@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label: Label = $MarginContainer/HBoxContainer/Label

@export var image: Texture2D:
	set(value):
		_image = value
		_sprite_changed()
	get:
		return _image

var _image: Texture2D

@export var number: int:
	set(value):
		_number = value
		_number_changed()
	get:
		return _number

var _number: int

func _ready() -> void:
	_sprite_changed()

func _sprite_changed() -> void:
	if texture_rect:
		texture_rect.texture = _image

func _number_changed() -> void:
	if label:
		label.text = str(_number)
