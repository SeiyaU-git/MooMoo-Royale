@tool
extends PanelContainer

@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect

@export var image: Texture2D:
	set(value):
		_image = value
		_sprite_changed()
	get:
		return _image

var _image: Texture2D

func _ready() -> void:
	_sprite_changed()

func _sprite_changed() -> void:
	if texture_rect:
		texture_rect.texture = _image
