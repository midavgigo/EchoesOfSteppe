extends StaticBody2D

var sprite = null
var action_area:Area2D = null
var block_controller = null
var can_action = false
var player = null

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
		action_area = $Area2D
		action_area.body_entered.connect(_on_entered)
		action_area.body_exited.connect(_on_exited)
	if get_meta("destroyable"):
		self.add_to_group("hittable")

func _process(delta):
	block_controller.process(delta)
	if can_action && Input.is_action_just_pressed("action"):
		block_controller.action(player)

func _on_entered(body):
	if body.is_in_group("player"):
		can_action = true
		player = body
		block_controller.on_entered(body)

func _on_exited(body):
	if body.is_in_group("player"):
		can_action = false
		block_controller.on_exited(body)
