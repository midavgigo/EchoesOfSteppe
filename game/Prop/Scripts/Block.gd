extends StaticBody2D

var sprite = null
var action_collider = null
var block_controller = null
var can_action = false
var player = null
@onready var collider = $CollisionShape2D

func hit(damage, material):
	block_controller.hit(damage, material)

func get_resist():
	return "none"

func _ready():
	var path:Resource = get_meta("script")
	block_controller = path.new(self)
	if get_meta("animated"):
		sprite = $AnimatedSprite2D
	else:
		sprite = $Sprite2D
	if get_meta("interactive"):
		$Area2D.body_entered.connect(_on_entered)
		$Area2D.body_exited.connect(_on_exited)
		action_collider = $Area2D/CollisionShape2D
	if get_meta("destroyable"):
		self.add_to_group("hittable")

func _process(delta):
	block_controller.process(delta)
	if can_action && Input.is_action_just_pressed("action"):
		block_controller.action(player)

func _on_entered(body):
	var is_player = false
	if body.is_in_group("player"):
		can_action = true
		player = body
		is_player = true
	block_controller.on_entered(body, is_player)

func _on_exited(body):
	var is_player = false
	if body.is_in_group("player"):
		can_action = false
		is_player = true
	block_controller.on_exited(body, is_player)
