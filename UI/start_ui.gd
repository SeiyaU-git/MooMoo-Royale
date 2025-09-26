extends Control


func _on_host_button_pressed() -> void:
	hide()
	NetworkHandler.start_server()
	


func _on_join_button_pressed() -> void:
	hide()
	NetworkHandler.start_client()
