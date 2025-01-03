extends Area2D

var is_player_owner: bool
@onready var hit_handle			= get_meta("hit_handle")
@onready var timeoff_handle		= get_meta("timeoff_handle")
@onready var speedoff_handle	= get_meta("speedoff_handle")
@onready var life_time			= get_meta("life_time")
@onready var controller			= get_meta("controller")
@onready var packed 			= get_meta("packed")
@onready var package			= get_meta("package") if packed else null
@onready var damage				= get_meta("damage")
var damage_type					= "weapon"

@onready var collider			= $CollisionShape2D
@onready var sprite				= ($AnimatedSprite2D if get_meta("animated") else $Sprite2D)

var speed: Vector2 				
const MIN_SPEED 				= 10

var time_left = 0

func initialize(speed: Vector2, is_player_owner: bool):
	self.speed 				= speed 
	self.is_player_owner 	= is_player_owner

func _ready():
	controller = controller.new(self)

func _process(delta):
	var past_speed = speed
	var past_position = position
	controller.process(delta)
	position = position + speed*delta
	rotation = atan2(speed.y, speed.x)
	if speed.length() <= MIN_SPEED:
		controller.speedoff(past_speed, past_position)
	if timeoff_handle and time_left < life_time:
		time_left += delta
		if time_left*1000 >= life_time:
			controller.timeoff()

func _on_body_entered(body):
	if hit_handle:
		var is_player = body.is_in_group("player")
		if is_player && not is_player_owner:
			body.set_hit(damage, damage_type)
		controller.body_entered(body, is_player)


func _on_body_exited(body):
	if hit_handle:
		controller.body_exited(body, body.is_in_group("player"))

func spawn():
	if packed:
		get_tree().root.add_child(package.instantiate())

func destroy():
	if packed:
		spawn()
	controller.destroy()
	queue_free()
