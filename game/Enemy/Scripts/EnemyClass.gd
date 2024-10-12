extends EnemyClass

const ConfReader	= preload("res://Tools/Scripts/ConfReader.gd")
const Movement		= preload("res://Tools/Scripts/Movement.gd")
class EnemyClass:
	class Attack:
		var distance
		var damage
		var type
		var style
		var data
	var movement 		= Movement.new(0, 0)
	var attack 			= Attack.new()
	var health
	var width
	var height
	var name
	var resist
	var controller
	
	var velocity 		= Vector2()
	var acceleration 	= Vector2()
	var effects			= []
	
	func _init(name):
		self.name			= name
		var reader			= ConfReader.new(ConfReader.Roots.ENEMY, "enemys", name)
		health 				= reader.getField("health")
		width 				= reader.getField("width")
		height 				= reader.getField("height")
		attack.distance		= reader.getField("attack/distance")
		attack.damage 		= reader.getField("attack/damage")
		attack.data 		= reader.getField("attack/data")
		attack.style 		= reader.getField("attack/style")
		attack.type 		= reader.getField("attack/type")
		movement.accel 		= reader.getField("movement/accel")
		movement.pattern	= reader.getField("movement/pattern")
		movement.speed 		= reader.getField("movement/speed")
		resist 				= reader.getField("resist")
		controller 			= reader.getField("controller")
		if controller != null:
			controller 		= load(controller).new()
	
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
		
		for i in effects:
			i.process(delta)
		
		if controller != null:
			controller.process(delta)
			
	func get_velocity():
		return velocity
	
	
