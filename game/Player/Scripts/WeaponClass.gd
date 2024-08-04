extends WeaponClass


class WeaponClass:
	var name
	var material
	var type
	var speed_q
	var damage
	var speed
	var armor
	var flesh
	var spirit
	
	func debug():
		return 	"name: "+name+\
				"\nmaterial: "+material+\
				"\ntype: "+type+\
				"\nspeed_q: "+str(speed_q)+\
				"\ndamage: "+str(damage)+"\n"
	
	func _init(name):
		self.name = name
		var file = FileAccess.open("res://Player/Configurations/test_weapons.json", FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				material = dict[name]["material"]
				type = dict[name]["type"]
				speed_q = dict[name]["speed_q"]
				damage = dict[name]["damage"]
		file = FileAccess.open("res://Player/Configurations/weapon_types.json", FileAccess.READ)
		dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				speed = dict[type]["speed"]
		file = FileAccess.open("res://Player/Configurations/weapon_materials.json", FileAccess.READ)
		dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				flesh = dict[material]["flesh"]
				armor = dict[material]["armor"]
				spirit = dict[material]["spirit"]
