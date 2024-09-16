extends TestFloorController

class TestFloorController:
	var floor
	func _init(floor):
		self.floor = floor
		print_debug("floor controller for \""+floor.title+"\" was initialized")
	
	func action(player):
		print_debug("floor "+floor.title+" was actioned by \""+player.PLAYER_NAME+"\"")
	
	func process(delta):
		pass
	
	func on_entered(body):
		print_debug("body "+str(body)+" is staying on the floor \""+floor.title+"\"")
	
	func on_exited(body):
		print_debug("body "+str(body)+" isn't staying anymore on the floor \""+floor.title+"\"")
