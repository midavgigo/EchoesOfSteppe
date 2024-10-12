extends Movement


class Movement:
	var speed
	var accel
	var pattern
	func _init(speed, accel, pattern="player"):
		self.speed = speed
		self.accel = accel 
