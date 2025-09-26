extends LineEdit

@onready var chat: PanelContainer = $"../Chat"

var typing := false

func _ready() -> void:
	hide()

func use() -> void:
	if typing:
		close()
	else:
		open()

func open() -> void:
	chat.clear()
	show()
	grab_focus()
	typing = true
	
	
func close() -> void:
	hide()
	release_focus()
	PlayerChat.create(get_parent().owner_id, text).send(NetworkHandler.server_peer)
	chat.show_messgage(text)
	typing = false
