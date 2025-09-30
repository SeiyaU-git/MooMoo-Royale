extends Node
## CLIENT ##

signal handle_local_id_assignment(local_id: int)
signal handle_remote_id_assignment(remote_id: int)

signal handle_player_transformation(player_position: PlayerTransformation)
signal handle_player_chat(player_chat: PlayerChat)
signal handle_player_attack(player_attack: PlayerAttackPacket)

signal handle_player_creation(id: int, name: String)

signal handle_player_deletion(id: int)

# Node signals

signal local_id_assigned(local_id: int)

var id: int = -1
var remote_ids: Array[int]

var client_name: String = "Unknown"

func _ready() -> void:
	NetworkHandler.on_client_packet.connect(on_client_packet)

func on_client_packet(data: PackedByteArray) -> void:
	var packet_type: int = data.decode_u8(0)
	match packet_type:
		PacketInfo.PACKET_TYPE.ID_ASSIGNMENT:
			manage_ids(IDAssignment.create_from_data(data))
		
		PacketInfo.PACKET_TYPE.ID_UNASSIGNMENT:
			remove_ids(IDUnassignment.create_from_data(data))
		
		PacketInfo.PACKET_TYPE.PLAYER_CREATION:
			manage_player_creation(PlayerCreation.create_from_data(data))
		
		PacketInfo.PACKET_TYPE.PLAYER_POSITION:
			handle_player_transformation.emit(PlayerTransformation.create_from_data(data))
		
		PacketInfo.PACKET_TYPE.PLAYER_CHAT:
			handle_player_chat.emit(PlayerChat.create_from_data(data))
		PacketInfo.PACKET_TYPE.PLAYER_ATTACK:
			handle_player_attack.emit(PlayerAttackPacket.create_from_data(data))
		
		_:
			push_error("Packet with index", data[0], "NOT HANDLED")

func manage_ids(id_assignment: IDAssignment) -> void:
	if id == -1: # When id == -1, the id sent by the server is for us
		id = id_assignment.id
		local_id_assigned.emit(id)
		print("Id has been locally assigned sucsessfully")
		
		#effectively spawning the player
		#handle_local_id_assignment.emit(id_assignment.id)
		
		remote_ids = id_assignment.remote_ids
		for remote_id in remote_ids:
			if remote_id == id: # skipps itsself 
				continue
			# code for each id here <---------->
			#handle_remote_id_assignment.emit(remote_id)

	else: # When id != -1, we already own an id, and just append the remote ids by the sent id
		remote_ids.append(id_assignment.id)
		#handle_remote_id_assignment.emit(id_assignment.id)

func remove_ids(id_unassignment: IDUnassignment) -> void:
	remote_ids.erase(id_unassignment.id)
	
	handle_player_deletion.emit(id_unassignment.id)

func player_creation_request(player_id: int, player_name: String = "not recived"):
	client_name = player_name
	print("player creation request with name", player_name)
	PlayerSpawn.create(player_id, player_name).send(NetworkHandler.server_peer)

func manage_player_creation(player_creation: PlayerCreation):
	for _id in player_creation.names.keys():
		handle_player_creation.emit(_id, player_creation.names[_id])
