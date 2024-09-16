extends Area2D

const ConfReader = preload("res://Tools/Scripts/ConfReader.gd")

var title = ""
var sprite = null

var floor_controller = null
var can_action = false
var player = null
var is_controlled = false

func _ready():
	title = self.get_meta("title")
	var reader = ConfReader.new(ConfReader.Roots.PROP, "floors", title)
	if reader.getField("animated"):
		sprite = $AnimatedSprite2D
	else:
		sprite = $Sprite2D
	var temp = reader.getField("script")
	match typeof(temp):
		TYPE_STRING:
			is_controlled = true
			floor_controller = load(temp).new(self)
			if reader.getField("action"):
				self.body_entered.connect(_on_entered)
				self.body_exited.connect(_on_entered)

func _process(delta):
	if is_controlled:
		floor_controller.process(delta)
		if can_action && Input.is_action_just_pressed("action"):
			floor_controller.action(player)

func _on_entered(body):
	if is_controlled:
		floor_controller.on_entered(body)
		if body.is_in_group("player"):
			can_action = true
			player = body



func _on_exited(body):
	if is_controlled:
		floor_controller.on_exited(body)
		if body.is_in_group("player"):
			can_action = false
