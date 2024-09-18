extends Area2D


var title = ""
var sprite = null

var floor_controller = null
var can_action = false
var player = null

func _ready():
	if get_meta("animated"):
		sprite = $AnimatedSprite2D
	else:
		sprite = $Sprite2D
	floor_controller = get_meta("script").new(self)
	if get_meta("action"):
		self.body_entered.connect(_on_entered)
		self.body_exited.connect(_on_entered)

func _process(delta):
	floor_controller.process(delta)
	if can_action && Input.is_action_just_pressed("action"):
		floor_controller.action(player)

func _on_entered(body):
	floor_controller.on_entered(body)
	if body.is_in_group("player"):
		can_action = true
		player = body



func _on_exited(body):
	floor_controller.on_exited(body)
	if body.is_in_group("player"):
		can_action = false
