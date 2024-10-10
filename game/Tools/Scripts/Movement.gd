extends Movement


class Movement:
	var speed
	var accel
	func _init(speed, accel):
		self.speed = speed
		self.accel = accel 
