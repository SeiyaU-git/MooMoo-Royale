extends Control

@onready var line_edit: LineEdit = $VBoxContainer/LineEdit


func _on_host_button_pressed() -> void:
	hide()
	NetworkHandler.start_server()


func _on_join_button_pressed() -> void:
	var client_name = line_edit.text
	
	hide()
	NetworkHandler.start_client()
