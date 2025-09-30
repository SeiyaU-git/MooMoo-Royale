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

var _age: int = 0
var age: int:
	set(value):
		_age = value
		if game_ui:
			game_ui.age_number.text = str("Age: ", _age)
	get:
		return _age

var _xp: float = 0
var xp: float:
	set(value):
		_xp = value
		if game_ui:
			game_ui.age_bar.value = _xp / max_xp * 100
		
		if _xp >= max_xp:
			_xp -= max_xp
			age += 1
	get:
		return _xp

var max_xp: float = 100

func _init() -> void:
	Global.player_manager = self

func _ready() -> void:
	game_ui = Layer.load_ui(GAME_UI, true)
	Global.game_ui = game_ui
	
	Global.game_ui.ping_display.text = str("Ping: ", NetworkHandler.server_peer.get_statistic(ENetPacketPeer.PEER_ROUND_TRIP_TIME), " ms")
