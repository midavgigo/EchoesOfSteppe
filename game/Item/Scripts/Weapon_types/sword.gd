extends Sword

const ConfReader		= preload("res://Tools/Scripts/ConfReader.gd")
const MaterialHandler	= preload("res://Item/Scripts/MaterialHandler.gd")

class Sword:
	const TYPE = "sword"
	
	var player
	
	var is_primary
	var material
	var damage
	var delay
	
	var can_hit		= true
	var passed_time	= 0
	func _init(player, name):
		self.player = player
		
		var reader	= ConfReader.new(ConfReader.Roots.ITEM, "weapon", name)
		is_primary	= reader.getField("is_primary")
		material	= MaterialHandler.new(reader.getField("material"))
	
	func process(delta):
		if not can_hit:
			passed_time += delta*1000
			if passed_time*(player.psq if is_primary else player.ssq) >= delay:
				can_hit		= true	
				passed_time	= 0
	
	func attack():
		var mdir = player.mdir()
		player.pweapon_area.rotate(atan2(mdir.y, mdir.x)- player.pweapon_area.rotation)
		for i in player.enemys:
			i.hit(damage*material[i.get_resist()], material[i.get_resist()])	
