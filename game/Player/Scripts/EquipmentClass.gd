extends EquipmentClass

class EquipmentClass:
	var name
	var slots
	var weapon
	var beast
	var spirit
	
	func debug():
		return 	"name: "+name+\
				"\nslots: "+str(slots)+\
				"\nweapon: "+str(weapon)+\
				"\nbeast: "+str(beast)+\
				"\nspirit: "+str(spirit)+"\n"
	
	func _init(name):
		self.name = name
		var file = FileAccess.open("res://Player/Configurations/test_equipments.json", FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				slots = dict[name]["slots"]
				weapon = dict[name]["weapon"]
				beast = dict[name]["beast"]
				spirit = dict[name]["spirit"]
