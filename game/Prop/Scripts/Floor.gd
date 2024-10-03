extends Area2D

var sprite = null
@onready var collider = $CollisionShape2D
var player = null

var floor_controller = null
var can_action = false

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
	if can_action && player.is_player_action():
		floor_controller.action(player)

func _on_entered(body):
	var is_player = false
	if body.is_in_group("player"):
		can_action = true
		player = body
		is_player = true
	floor_controller.on_entered(body, is_player)



func _on_exited(body):
	var is_player = false
	if body.is_in_group("player"):
		can_action = false
		is_player = true
	floor_controller.on_exited(body, is_player)
