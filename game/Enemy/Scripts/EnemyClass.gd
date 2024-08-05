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
		var source
	var movement
	var attack
	var health
	var width
	var height
	
	func _init(name):
		var file = FileAccess.open("res://Enemy/Configuration/enemys.json", FileAccess.READ)
		
