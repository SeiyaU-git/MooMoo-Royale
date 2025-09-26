extends Control

@onready var line_edit: LineEdit = $VBoxContainer/LineEdit


func _on_host_button_pressed() -> void:
	hide()
	NetworkHandler.start_server()


func _on_join_button_pressed() -> void:
	var client_name: String = line_edit.text
	
	hide()
	NetworkHandler.start_client()
	
	await ClientNetworkGlobals.local_id_assigned
	
	if client_name.strip_edges() == "":
		client_name = "Unknown"
	
	ClientNetworkGlobals.player_creation_request(ClientNetworkGlobals.id, client_name)
