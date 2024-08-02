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
	
	func is_run():
		return run
		
	func set_run(flag):
		run = flag
	
	func set_joy(hor, ver):
		acceleration.x = hor * (data["walk"]["accel"]+data["run"]["accel"])
		acceleration.y = ver * (data["walk"]["accel"]+data["run"]["accel"])
		if run:
			acceleration = acceleration.limit_length(data["walk"]["accel"]+data["run"]["accel"])
		else:
			acceleration = acceleration.limit_length(data["walk"]["accel"])
	
	func calc(delta):
		if acceleration.length() == 0:
			acceleration = -velocity
		velocity += acceleration*delta
		if run:
			velocity = velocity.limit_length(data["walk"]["speed"]+data["run"]["speed"])
		else:
			velocity = velocity.limit_length(data["walk"]["speed"])
			
		
	func get_velocity():
		return velocity
		
			
