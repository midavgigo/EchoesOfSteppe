extends TestMissile

class TestMissile:
	var missile
	
	func _init(missile):
		self.missile = missile
		missile.speed = Vector2(1, 1)
	
	func process(delta):
		missile.speed -= missile.speed*delta/2
	
	func speedoff(past_speed, past_position):
		missile.destroy()
		print("ОШИБКА СТОП СКОРОСТЬ")
	
	func timeoff():
		missile.destroy()
		print("ОШИБКА СТОП ВРЕМЯ")
		
	func body_entered(body, is_player):
		print("ХДЫЩ")
	
	func body_exited(body, is_player):
		print("ВЫХДЫЩ")
		
	func destroy():
		print("о нееееет")
