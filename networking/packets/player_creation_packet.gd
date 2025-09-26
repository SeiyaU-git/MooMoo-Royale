extends PacketInfo
class_name PlayerCreation

var names: Dictionary[int, String]
var name: String = ""


static func create(names: Dictionary[int, String]) -> PlayerCreation:
	var info: PlayerCreation = PlayerCreation.new()
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.packet_type = PACKET_TYPE.PLAYER_CREATION
	info.names = names
	
	return info

static func create_from_data(data: PackedByteArray) -> PlayerCreation:
	var info: PlayerCreation = PlayerCreation.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data := super.encode() # contains packet_type

	# Write number of names
	data.append(names.size())

	for key in names.keys():
		var _name: String = names[key]
		var name_bytes: PackedByteArray = _name.to_utf8_buffer()
		
		# Write key
		data.append(key)
		
		# Write name length
		data.append(name_bytes.size())
		
		# Write actual string bytes
		data.append_array(name_bytes)
	
	return data



func decode(data: PackedByteArray) -> void:
	super.decode(data)

	var index := 1  # skip packet_type
	var names_amount := data[index]; index += 1

	for i in range(names_amount):
		var _id := data[index]; index += 1
		var name_length := data[index]; index += 1

		var name_bytes := data.slice(index, index + name_length)
		var _name := name_bytes.get_string_from_utf8()
		index += name_length

		names[_id] = _name
