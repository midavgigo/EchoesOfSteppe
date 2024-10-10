extends EStep

class EStep:
	const DODGE_TIME	= 125
	const SPEED_COEF	= 10
	
	var player
	
	var calls			= ["dodge", "process"]
	var passed_time		= 0
	
	func is_call(call):
		return call in calls
	
	func _init(player):
		self.player = player
	
	func dodge():
		if not player.dodging:
			player.dodging = true
		
	func process(delta):
		if player.dodging:
			player.velocity *= SPEED_COEF
			passed_time += delta*1000
			if passed_time >= DODGE_TIME:
				player.dodging 	= false 
				passed_time	= 0
