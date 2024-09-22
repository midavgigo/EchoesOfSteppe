extends DoorMovingController

class DoorMovingController:
	var block:StaticBody2D = null
	var vector_move = null
	var opened = false
	#Конструктор, в который передаётся объект блока
	func _init(block):
		self.block = block
		var collider: CollisionShape2D = block.collider
		vector_move = Vector2(0, collider.shape.get_rect().size.y)
	
	func on_entered(body, is_player):
		pass
		
	func on_exited(body, is_player):
		pass
		
	func hit(damage, material):
		pass
	#Функция, вызываемая циклически 
	func process(delta):
		pass
	
	#Функция, вызываемая при взаимодействии с блоком
	#Вызывается если в поле action_area/action указано true
	#player - объект игрока
	func action(player):
		if not opened:
			block.position += vector_move
		else:
			block.position -= vector_move
		opened = not opened
