extends TestBlockController

class TestBlockController:
	var block = null
	#Конструктор, в который передаётся объект блока
	func _init(block):
		self.block = block
		print_debug("block controller for \""+block.title+"\" is initialized")
	
	#Функция, которая нужна если в поле destroy указан hit
	#Она вызывается тогда, когда по блоку проходит удар с уроном damage и материал оружия material
	func hit(damage, material):
		print_debug("block \""+block.title+"\" was hitten with damage:"+str(damage)+" and material:"+str(material))
	
	func set_hittable():
		print_debug("block \""+block.title+"\" can be hitten")
	
	#Функция, вызываемая циклически 
	func process(delta):
		pass
	
	#Функция, вызываемая при взаимодействии с блоком
	#Вызывается если в поле action_area/action указано true
	#player - объект игрока
	func action(player):
		print_debug("player \""+player.PLAYER_NAME+"\" was actioned with block \""+block.title+"\"")
	
