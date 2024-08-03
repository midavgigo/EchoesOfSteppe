extends EquipmentClass

class EquipmentClass:
	var slots;
	var weapon;
	var beast;
	var spirit;
	
	func _init(name):
		var file = FileAccess.open("res://Player/Configurations/test_equipments.json", FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				slots = dict[name]["slots"]
				weapon = dict[name]["weapon"]
				beast = dict[name]["beast"]
				spirit = dict[name]["spirit"]
