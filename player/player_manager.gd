extends Node
class_name PlayerManager

const GAME_UI = preload("uid://dhea3qmpokodb")
var game_ui: GameUI

var _gold: int = 0
var gold: int:
	set(value):
		_gold = value
		if game_ui:
			game_ui.gold_display.number = value
	get:
		return _gold


var _food: int = 0
var food: int:
	set(value):
		_food = value
		if game_ui:
			game_ui.food_display.number = value
	get:
		return _food

var _wood: int = 0
var wood: int:
	set(value):
		_wood = value
		if game_ui:
			game_ui.wood_display.number = value
	get:
		return _wood


var _stone: int = 0
var stone: int:
	set(value):
		_stone = value
		if game_ui:
			game_ui.stone_display.number = value
	get:
		return _stone


var _kills: int = 0
var kills: int:
	set(value):
		_kills = value
		if game_ui:
			game_ui.kills_display.number = value
	get:
		return _kills

func _init() -> void:
	Global.player_manager = self

func _ready() -> void:
	game_ui = Layer.load_ui(GAME_UI, true)
