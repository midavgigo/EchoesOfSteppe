extends Player

class Player:
	var health;
	var stamina;
	var walk;
	var attack;
	var dodge_type;
	var acceleration = Vector2();
	var velocity = Vector2();
	
	func _init(name):
		var file = FileAccess.open("res://Player/Configurations/test_players.json", FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				health = dict[name]["health"]
				stamina = dict[name]["stamina"]
				walk = dict[name]["walk"]
				attack = dict[name]["attack"]
				dodge_type = dict[name]["dodge_type"]
	
	func set_joy(hor, ver):
		acceleration.x = hor * walk["accel"]
		acceleration.y = ver * walk["accel"]
	
	func calc(delta):
		if acceleration.length() == 0:
			acceleration = -velocity*13.5
		velocity += acceleration*delta
		velocity = velocity.limit_length(walk["speed"])
			
	func get_velocity():
		return velocity
