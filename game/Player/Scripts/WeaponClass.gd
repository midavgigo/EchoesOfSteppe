extends WeaponClass


class WeaponClass:
	var name
	var material
	var type
	var speed
	var damage
	

	func debug():
		return 	"name: "+name+\
				"\nmaterial: "+material+\
				"\ntype: "+type+\
				"\nspeed: "+str(speed)+\
				"\ndamage: "+str(damage)+"\n"
	
	func _init(name):
		self.name = name
		var file = FileAccess.open("res://Player/Configurations/test_weapons.json", FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				material = dict[name]["material"]
				type = dict[name]["type"]
				speed = dict[name]["speed"]
				damage = dict[name]["damage"]
