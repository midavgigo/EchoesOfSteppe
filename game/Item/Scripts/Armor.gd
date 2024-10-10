extends Armor

const ConfReader	= preload("res://Tools/Scripts/ConfReader.gd")

class Armor:
	var name
	var slots
	var weapon
	var beast
	var spirit
	
	func debug():
		return 	"name: "+name+\
				"\nslots: "+str(slots)+\
				"\nweapon: "+str(weapon)+\
				"\nbeast: "+str(beast)+\
				"\nspirit: "+str(spirit)+"\n"
	
	func _init(name):
		self.name	= name
		var reader	= ConfReader.new(ConfReader.Roots.ITEM, "armor", name)
		slots		= reader.getField("slots")
		weapon		= reader.getField("weapon")
		beast		= reader.getField("beast")
		spirit		= reader.getField("spirit")
	
