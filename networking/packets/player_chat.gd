extends PacketInfo
class_name PlayerChat

var id: int
var text: String

static func create(id: int, text: String) -> PlayerChat:
	var info: PlayerChat = PlayerChat.new()
	info.packet_type = PACKET_TYPE.PLAYER_CHAT
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.id = id
	
	info.text = text
	return info

static func create_from_data(data: PackedByteArray) -> PlayerChat:
	var info: PlayerChat = PlayerChat.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	var text_bytes: PackedByteArray = text.to_utf8_buffer()
	data.append(id)
	data.append(text.length())
	
	data.append_array(text_bytes)

	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	var length = data.decode_u8(2)
	
	var text_bytes := data.slice(3, 3 + length)
	text = text_bytes.get_string_from_utf8()
	
