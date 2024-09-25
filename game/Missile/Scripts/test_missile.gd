extends TestMissile

class TestMissile:
	var missile
	
	func _init(missile):
		self.missile = missile
		missile.speed = Vector2(1, 1)
	
	func process(delta):
		pass
	
	func speedoff():
		pass
	
	func timeoff():
		pass
		
	func body_entered(body, is_player):
		pass
	
	func body_exited(body, is_player):
		pass
		
	func destroy():
		pass
