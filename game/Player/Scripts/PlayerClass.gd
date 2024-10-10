extends Player

const ConfReader	= preload("res://Tools/Scripts/ConfReader.gd")
const Movement		= preload("res://Tools/Scripts/Movement.gd")
const Inventory		= preload("res://Player/Scripts/Inventory.gd")

const PLAYER_STOP_COEF	= 13.5

class Player:
	# conf
	var name
	var movement
	var max_health
	var inventory
	# vars
	var health
	var acceleration	= Vector2()
	var velocity		= Vector2()
	var player
	var psq				= 1
	var ssq				= 1
	
	func debug():
		return 	"name: "			+name+\
				"\nhealth: "		+str(health)+\
				"\nmax health: "	+str(max_health)+\
				"\nmovement: "		+str(movement)+\
				"\nacceleration: "	+str(acceleration)+\
				"\nvelocity: "		+str(velocity)
	
	func _init(player, name):
		self.player	= player
		self.name	= name
		
		var reader	= ConfReader.new(ConfReader.Roots.PLAYER, "player", name)
		health 		= reader.getField("health")
		max_health	= health
		movement 	= Movement.new(reader.getField("movement/speed"), \
									reader.getField("movement/accel"))
		inventory	= Inventory.new(player,\
									reader.getField("items/armor"),\
									reader.getField("items/pweapon"),\
									reader.getField("items/sweapon"),\
									reader.getField("items/slots")
									)
		player.pweapon_anim.sprite_frames = load("res://Item/Animations/"+inventory.pweapon.TYPE+".tres")
		player.pweapon_anim.set_speed_scale(1000/inventory.pweapon.delay)
	
	func set_joy(hor, ver):
		acceleration.x = hor * movement.accel
		acceleration.y = ver * movement.accel
	
	func calc(delta):
		if acceleration.length() == 0:
			acceleration = -velocity*PLAYER_STOP_COEF
		velocity += acceleration*delta
		velocity = velocity.limit_length(movement.speed)
			
	func get_velocity():
		return velocity
