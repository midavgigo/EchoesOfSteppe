extends WeaponClass

const ConfReader = preload("res://Tools/Scripts/ConfReader.gd") 

class WeaponClass:
	var name
	var material
	var type
	var speed_q
	var damage
	var speed
	var armor
	var flesh
	var spirit
	
	func debug():
		return 	"name: "+name+\
				"\nmaterial: "+material+\
				"\ntype: "+type+\
				"\nspeed_q: "+str(speed_q)+\
				"\ndamage: "+str(damage)+"\n"
	
	func _init(name):
		self.name = name
		var cf_reader = ConfReader.new(ConfReader.Roots.PLAYER, "weapons", "") 
