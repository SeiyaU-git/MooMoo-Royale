extends PacketInfo
class_name PlayerTransformation

var id: int
var position: Vector2
var rotation: float

static func create(id: int, position: Vector2, rotation : float) -> PlayerTransformation:
	var info: PlayerTransformation = PlayerTransformation.new()
	info.packet_type = PACKET_TYPE.PLAYER_POSITION
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.id = id
	info.position = position
	info.rotation = rotation
	return info

static func create_from_data(data: PackedByteArray) -> PlayerTransformation:
	var info: PlayerTransformation = PlayerTransformation.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()	
	data.resize(14)
	data.encode_u8(1, id)
	
	data.encode_float(2, position.x)
	data.encode_float(6, position.y)
	
	data.encode_float(10, rotation)
	
	return data
	

# CURRENT DATA ARRANGEMENT
# [TYPE, ID, POSITION X, POSITION Y, ROTATION] what data
# [1,    1,  4,          4,          4] space taken
# [0,    1,  2,          6,          10] index 
# total 14

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	position = Vector2(data.decode_float(2), data.decode_float(6))
	rotation = data.decode_float(10)
