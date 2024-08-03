extends WeaponClass

#"material": "test_material",
		#"type": "test_type",
		#"speed": 1, 
		#"damage": 0.5

class WeaponClass:
	var material;
	var type;
	var speed;
	var damage;
	
	func _init(name):
		var file = FileAccess.open("res://Player/Configurations/test_weapons.json", FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				material = dict[name]["material"]
				type = dict[name]["type"]
				speed = dict[name]["speed"]
				damage = dict[name]["damage"]
