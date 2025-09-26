extends Node

signal handle_player_transformation(peer_id: int, player_position: PlayerTransformation)

var peer_ids: Array[int]

func _ready() -> void:
	NetworkHandler.on_peer_connected.connect(on_peer_connected)
	NetworkHandler.on_peer_disconnected.connect(on_peer_disconnected)
	NetworkHandler.on_server_packet.connect(on_server_packet)


func on_peer_connected(peer_id: int) -> void:
	peer_ids.append(peer_id)
	
	#DATA GETS CREATED AND BROADCASTED
	IDAssignment.create(peer_id, peer_ids).broadcast(NetworkHandler.connection)


func on_peer_disconnected(peer_id: int) -> void:
	peer_ids.erase(peer_id)

	# Create IDUnassignment to broadcast to all still connected peers


func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	var data_type = data[0]
	match data_type:
		PacketInfo.PACKET_TYPE.PLAYER_POSITION:
			handle_player_transformation.emit(peer_id, PlayerTransformation.create_from_data(data))
		_:
			push_error("Packet type with index ", data[0], " unhandled!")
