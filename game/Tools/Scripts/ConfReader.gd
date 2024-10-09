extends ConfReader

const PATHS = [
	"Item/Configurations/",
	"Enemy/Configurations/",
	"Missile/Configurations/",
	"Player/Configurations/",
	"Prop/Configurations/",
	"Tool/Configurations/"
];

enum Roots{
	ITEM,
	ENEMY,
	MISSILE,
	PLAYER,
	PROP,
	TOOL
}

class ConfReader:
	var root
	var path
	var dict
	func _init(root: Roots, path: String, name: String):
		self.root = root
		self.path = path
		var file = FileAccess.open("res://"+PATHS[root] + path + ".json", FileAccess.READ)
		self.dict = JSON.parse_string(file.get_as_text())
		match typeof(self.dict):
			TYPE_DICTIONARY:
				self.dict = self.dict[name]
				print_debug("OK:\tconfiguration ", path, " was readed succesfuly")
			TYPE_NIL:
				self.dict = Dictionary()
				print_debug("Warning:\t configuration ", path, " was not readed. Creating empty configuration")
	
	func getField(path: String):
		var elems = path.split("/")
		var el = self.dict.duplicate(true)
		for i in elems:
			if el == TYPE_NIL:
				return TYPE_NIL
			el = el[i]
		var ret:String = el
		if ret in ["true", "false"]:
			return ret == "true"
		if ret.is_valid_int():
			return ret.to_int()
		if ret.is_valid_float():
			return ret.to_float()
		return ret
	
	func getDict():
		return self.dict
	
#	func setField(value, path:String):
#		var elems = path.split("/")
#		var ref = self.dict
#		var last = elems[-1]
#		elems.pop()
#		for i in elems:
#			ref = ref[i]
#		ref[last] = value
#		
#	func write():
#		pass
	
