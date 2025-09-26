extends Node
## SEVER ##

signal on_peer_joined(player_id: int, player_name: String)

signal handle_player_transformation(peer_id: int, player_position: PlayerTransformation)
signal handle_player_chat(peer_id: int, text: String)

var peer_ids: Array[int]

var peer_names: Dictionary[int, String]

func _ready() -> void:
	NetworkHandler.on_peer_connected.connect(on_peer_connected)
	NetworkHandler.on_peer_disconnected.connect(on_peer_disconnected)
	NetworkHandler.on_server_packet.connect(on_server_packet)
	

func on_peer_connected(peer_id: int) -> void:
	peer_ids.append(peer_id)
	
	#DATA GETS CREATED AND BROADCASTED
	IDAssignment.create(peer_id, peer_ids).broadcast(NetworkHandler.connection)

func handle_player_spawn(player_spawn: PlayerSpawn):
	var _id = player_spawn.id
	var _name = player_spawn.name
	peer_names[_id] = _name
	
	print(peer_names)
	PlayerCreation.create(peer_names).broadcast(NetworkHandler.connection)
	on_peer_joined.emit(_id, _name)

func on_peer_disconnected(peer_id: int) -> void:
	peer_ids.erase(peer_id)

	# Create IDUnassignment to broadcast to all still connected peers


func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	var data_type = data[0]
	#print("server recived packet, type: ", data_type)
	match data_type:
		PacketInfo.PACKET_TYPE.PLAYER_SPAWN:
			handle_player_spawn(PlayerSpawn.create_from_data(data))
		
		PacketInfo.PACKET_TYPE.PLAYER_CHAT:
			var chat_data = PlayerChat.create_from_data(data)
			chat_data.broadcast(NetworkHandler.connection)
			print(str(peer_names[chat_data.id], " said : ", chat_data.text))
			#handle_player_chat.emit(chat_data.id, chat_data.text)
			
		PacketInfo.PACKET_TYPE.PLAYER_POSITION:
			handle_player_transformation.emit(peer_id, PlayerTransformation.create_from_data(data))
			
		_:
			push_error("Packet type with index ", data[0], " unhandled!")
