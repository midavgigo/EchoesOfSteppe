extends EnemyClass

class EnemyClass:
	class Movement:
		var speed
		var accel
		var pattern
	class Attack:
		var distance
		var damage
		var type
		var style
		var data
	var movement = Movement.new()
	var attack = Attack.new()
	var health
	var width
	var height
	var name
	var resist
	
	var velocity = Vector2()
	var acceleration = Vector2()
	
	func _init(name):
		self.name = name
		var file = FileAccess.open("res://Enemy/Configuration/enemys.json", FileAccess.READ)
		var dict = JSON.parse_string(file.get_as_text())
		match typeof(dict):
			TYPE_DICTIONARY:
				health = dict[name]["health"]
				width = dict[name]["width"]
				height = dict[name]["height"]
				attack.distance = dict[name]["attack"]["distance"]
				attack.damage = dict[name]["attack"]["damage"]
				attack.data = dict[name]["attack"]["data"]
				attack.style = dict[name]["attack"]["style"]
				attack.type = dict[name]["attack"]["type"]
				movement.accel = dict[name]["movement"]["accel"]
				movement.pattern = dict[name]["movement"]["pattern"]
				movement.speed = dict[name]["movement"]["speed"]
				resist = dict[name]["resist"]
	
	func set_target(pos, tar):
		var vec = (tar - pos).normalized()
		vec *= movement.accel
		acceleration = vec
	
	func stop():
		acceleration = Vector2()
	
	func calc(delta):
		if acceleration.length() == 0:
			acceleration = -velocity*13.5
		velocity += acceleration*delta
		velocity = velocity.limit_length(movement.speed)
			
	func get_velocity():
		return velocity
