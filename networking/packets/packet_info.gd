## BASE CLASS ##

class_name PacketInfo

enum PACKET_TYPE{
	ID_ASSIGNMENT = 0,
	ID_UNASSIGNMENT = 1,
	
	PLAYER_POSITION = 10,
	PLAYER_CHAT = 11,
	PLAYER_ATTACK = 12,

	PLAYER_SPAWN = 30,
	PLAYER_CREATION = 40,
}

var packet_type: PACKET_TYPE
var flag: int

# Override function in derived classes

func encode() -> PackedByteArray:
	var data: PackedByteArray
	data.resize(1)
	data.encode_u8(0, packet_type)
	
	return data

func decode(data: PackedByteArray) -> void:
	packet_type = data.decode_u8(0)

func send(target: ENetPacketPeer) -> void:
	target.send(0, encode(), flag)

func broadcast(server: ENetConnection) -> void:
	server.broadcast(0, encode(), flag)
