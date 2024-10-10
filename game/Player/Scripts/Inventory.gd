extends Inventory

const Armor			= preload("res://Item/Scripts/Armor.gd")
const Weapon		= preload("res://Item/Scripts/Weapon.gd")

class Inventory:
	var player
	var armor
	var pweapon
	var sweapon
	var slots	= []
	
	func _init(player, n_armor, n_pweapon, n_sweapon, n_slots):
		self.player		= player
		armor			= Armor.new(n_armor)
		pweapon			= Weapon.get_weapon(player, n_pweapon)
		sweapon			= Weapon.get_weapon(player, n_sweapon)
		var slots_list	= n_slots.split(",")
		for i in range(0, armor.slots):
			if i >= slots_list.size():
				break
			slots.append(load("res://Item/Scripts/Slots/"+slots_list[i]+".gd").new(player))
