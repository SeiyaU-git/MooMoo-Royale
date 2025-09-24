extends PacketInfo
class_name name

static func create() -> name:
	var info: name = name.new()
	
	return info

static func create_from_data(data: PackedByteArray) -> name:
	var info: name = name.new()
	info.deco(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	
