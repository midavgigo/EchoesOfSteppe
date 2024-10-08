extends EStep

class EStep:
	const DODGE_TIME	= 125
	
	var player
	
	var dodging			= false
	var calls			= ["dodge", "process"]
	var passed_time		= 0
	
	func is_call(call):
		return call in calls
	
	func _init(player):
		self.player = player
	
	func dodge():
		if not dodging:
			dodging = true
		
	func process(delta):
		if dodging:
			player.velocity *= 10
			passed_time += delta*1000
			if passed_time >= DODGE_TIME:
				dodging 	= false 
				passed_time	= 0
