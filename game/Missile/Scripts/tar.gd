extends TarMissile

class TarMissile:
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
		
	func body_entered(body, is_player_owner, destroy_):
		body.add_effect("tar", 0.1)
		if destroy_:
			missile.destroy()
			return
	
	func body_exited(body, is_player):
		print("ВЫХДЫЩ")
		
	func destroy():
		print("о нееееет")
