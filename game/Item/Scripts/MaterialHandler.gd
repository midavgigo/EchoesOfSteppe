extends MaterialHandler

const ConfReader = preload("res://Tools/Scripts/ConfReader.gd")

class MaterialHandler:
	
	var data
	
	func _init(name):
		var reader	= ConfReader.new(ConfReader.Roots.ITEM, "weapon_materials", name)
		var no_damage = reader.getField("no_damage")
		if no_damage != null && no_damage:
			data = {
				"armor": 	0,
				"flesh": 	0,
				"spirit":	0
			}
		else:
			data = reader.getDict()
	
