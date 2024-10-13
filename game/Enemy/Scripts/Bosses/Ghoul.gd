extends Ghoul

class Ghoul:
	const IS_BOSS 		= true
	const TARGET_TIME	= 1500
	
	var enemyClass
	var plates_count 	= 4
	var tarred			= false
	var passed_time		= 0
	var should_target	= true
	
	func _init(enemyClass):
		self.enemyClass = enemyClass
	
	func process(delta):
		if not tarred:
			for i in enemyClass.effects:
				if i.NAME == "tar":
					tarred = true
		else:
			if should_target:
				passed_time += delta*1000
				enemyClass.total_stop()
				if passed_time >= TARGET_TIME:
					should_target = false
					enemyClass.velocity *= 10
					passed_time = 0
			else:
				enemyClass.velocity *= 10
	
	func set_hit(damage, material):
		enemyClass.health -= damage * (0.2 + 0.2*(4-plates_count))
	
	func collide(body):
		if tarred && not should_target:
			should_target = true
			if body.is_in_group("player"):
				enemyClass.enemy.player.set_hit(0.25, "forced")
