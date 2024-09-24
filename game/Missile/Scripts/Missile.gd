extends RigidBody2D

@onready var hit_handle			= get_meta("hit_handle")
@onready var timeoff_handle		= get_meta("timeoff_handle")
@onready var speedoff_handle	= get_meta("speedoff_handle")
@onready var life_time			= get_meta("life_time")
@onready var controller			= get_meta("controller")
@onready var packed 			= get_meta("package")
@onready var package			= get_meta("package") if packed else null
@onready var damage				= get_meta("damage")
var damage_type					= "weapon"

@onready var collider			= $CollisionShape2D
@onready var sprite				= ($AnimatedSprite2D if get_meta("animated") else $Sprite2D)

var speed: Vector2 				= Vector2()
const MIN_SPEED 				= 0.1

var time_left = 0

func init(speed: Vector2):
	self.speed = speed 
	controller = controller.new(self)

func _process(delta):
	var past_speed = speed
	var past_position = position
	controller.process(delta)
	move_and_collide(speed*delta)
	if speed.length() <= MIN_SPEED:
		controller.speedoff(past_speed, past_position)
	if timeoff_handle and time_left < life_time:
		time_left += delta
		if time_left >= life_time:
			controller.timeoff()

func _on_body_entered(body):
	if hit_handle:
		var is_player = false
		if body.is_in_group("player"):
			body.set_hit(damage, damage_type)
			is_player = true
		controller.body_entered(body, is_player)


func _on_body_exited(body):
	if hit_handle:
		controller.body_exited(body, body.is_in_group("player"))

func destroy():
	if packed:
		pass #добавить спавн пакета
	controller.destroy()
	queue_free()
