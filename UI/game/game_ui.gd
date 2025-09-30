extends Control
class_name GameUI

@onready var food_display: MaterialDisplay = $MaterialBox/FoodDisplay
@onready var wood_display: MaterialDisplay = $MaterialBox/WoodDisplay
@onready var stone_display: MaterialDisplay = $MaterialBox/StoneDisplay

@onready var gold_display: MaterialDisplay = $GoldDisplay

@onready var kills_display: MaterialDisplay = $KillsDisplay

@onready var age_bar: ProgressBar = $AgeBar
@onready var age_number: ValueLabel = $AgeNumber

@onready var leader_bored: TextEdit = $LeaderBored

@onready var map: PanelContainer = $Map

@onready var ping_display: ValueLabel = $PingDisplay
