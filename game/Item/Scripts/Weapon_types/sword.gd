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
		delay		= reader.getField("delay")
		material	= MaterialHandler.new(reader.getField("material"))
		damage		= reader.getField("damage")
	
	func process(delta):
		if not can_hit:
			passed_time += delta*1000
			if passed_time*(player.player.psq if is_primary else player.player.ssq) >= delay:
				can_hit		= true	
				passed_time	= 0
	
	func attack():
		player.pweapon_anim.visible = true
		player.pweapon_anim.play("default")
		player.hitting = true
		if can_hit:
			for i in player.enemys:
				i.set_hit(damage*material.data[i.get_resist()], material.data[i.get_resist()])	
			can_hit = false
