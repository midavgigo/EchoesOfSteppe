extends Tar

class Tar:
	const NAME = "tar"
	
	var body
	var value
	
	func _init(body, value):
		self.body = body
		self.value = value
	
	func process(delta):
		if value >= 1:
			body.can_hit = false
	
	func add_value(value):
		self.value = min(1, value+self.value)
