extends TestFloorController

class TestFloorController:
	var floor
	func _init(floor):
		self.floor = floor
		print_debug("floor controller for was initialized")
	
	func action(player):
		print_debug("floor was actioned by \""+player.PLAYER_NAME+"\"")
	
	func process(delta):
		pass
	
	func on_entered(body, is_player):
		print_debug("body "+str(body)+" is staying on the floor")
	
	func on_exited(body, is_player):
		print_debug("body "+str(body)+" isn't staying anymore on the floor")
