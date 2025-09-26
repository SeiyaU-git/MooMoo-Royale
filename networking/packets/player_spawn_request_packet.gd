extends PacketInfo
class_name PlayerSpawn

var id: int
var name: String = ""


static func create(id: int, name: String) -> PlayerSpawn:
	var info: PlayerSpawn = PlayerSpawn.new()
	info.packet_type = PACKET_TYPE.PLAYER_SPAWN
	info.id = id
	info.name = name
	
	return info

static func create_from_data(data: PackedByteArray) -> PlayerSpawn:
	var info: PlayerSpawn = PlayerSpawn.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data := super.encode() # contains packet_type

	# Write packet id
	data.append(id)
	
	var name_bytes: PackedByteArray = name.to_utf8_buffer()
	data.append(name_bytes.size())
	data.append_array(name_bytes)
	return data



func decode(data: PackedByteArray) -> void:
	super.decode(data)

	var index := 1  # skip packet_type
	id = data[index]; index += 1
	var name_length := data[index]; index += 1
	
	var name_bytes := data.slice(index, index + name_length)
	index += name_length
	
	name = name_bytes.get_string_from_utf8()
