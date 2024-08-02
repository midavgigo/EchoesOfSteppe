extends Player

class Player:
	var data;
	var acceleration = Vector2();
	var velocity = Vector2();
	var run = false;
	
	func _init(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				data = dict
	
	func set_joy(hor, ver):
		acceleration.x = hor * data["walk"]["accel"]
		acceleration.y = ver * data["walk"]["accel"]
	
	func calc(delta):
		if acceleration.length() == 0:
			acceleration = -velocity*13.5
		velocity += acceleration*delta
		if run:
			velocity = velocity.limit_length(data["walk"]["speed"]+data["run"]["speed"])
		else:
			velocity = velocity.limit_length(data["walk"]["speed"])
			
	func get_velocity():
		return velocity
