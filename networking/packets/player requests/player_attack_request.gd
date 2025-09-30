extends PacketInfo
class_name PlayerAttackPacket

var id: int

static func create(id: int) -> PlayerAttackPacket:
	var info: PlayerAttackPacket = PlayerAttackPacket.new()
	info.packet_type = PACKET_TYPE.PLAYER_ATTACK
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.id = id
	
	return info

static func create_from_data(data: PackedByteArray) -> PlayerAttackPacket:
	var info: PlayerAttackPacket = PlayerAttackPacket.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.append(id)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
