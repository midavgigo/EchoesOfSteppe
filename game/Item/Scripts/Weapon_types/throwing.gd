extends Throwing

const ConfReader = preload("res://Tools/Scripts/ConfReader.gd")

class Throwing:
	var player
	# conf
	var missile
	var delay
	var is_primary
	# self
	var passed_time	= 0
	var can_shoot	= true
	
	
	func _init(player, name):
		self.player	= player
		
		var reader	= ConfReader.new(ConfReader.Roots.ITEM, "weapon", name)
		missile		= load("res://Missile/Scenes/"+reader.getField("missile")+".tscn")
		delay		= reader.getField("delay")
		is_primary	= reader.getField("is_primary")
		
	func process(delta):
		if not can_shoot:
			passed_time += delta*1000
			if passed_time*(player.psq if is_primary else player.ssq) >= delay:
				can_shoot = true
				passed_time = 0
	
	func attack():
		var mdir = player.mdir()*1000
		
		var msl = self.missile.instantiate()
		msl.position = player.positionv
		
		player.get_tree().root.add_child(msl)
		player.get_tree().root.get_children()[-1].initialize(mdir, false)
		
		can_shoot = false

