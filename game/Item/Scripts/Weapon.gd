extends Weapon

const ConfReader	= preload("res://Tools/Scripts/ConfReader.gd")

class Weapon:
	static func get_weapon(player, name):
		var reader	= ConfReader.new(ConfReader.Roots.ITEM, "weapon", name)
		return load("res://Item/Scripts/Weapon_types/"+reader.getField("type")+".gd").new(player, name)
