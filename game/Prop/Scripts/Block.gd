extends StaticBody2D

const ConfReader = preload("res://Tools/Scripts/ConfReader.gd")

var title = ""
var sprite = null
var action_area:Area2D = null
var block_controller = null
var can_action = false
var player = null
var is_controlled = false
@onready var collider = $CollisionShape2D

func hit(damage, material):
	block_controller.hit(damage, material)

func get_resist():
	return "none"

func _ready():
	title = self.get_meta("title")
	var reader = ConfReader.new(ConfReader.Roots.PROP, "blocks", title)
	if not reader.getField("animated"):
		sprite = $Sprite2D
	else:
		sprite = $AnimatedSprite2D
	var temp = reader.getField("script")
	match typeof(temp):
		TYPE_STRING:
			is_controlled = true
			block_controller = load(temp).new(self)
			if reader.getField("action"):
				action_area = $Area2D
				action_area.body_entered.connect(_on_entered)
				action_area.body_exited.connect(_on_exited)
			if reader.getField("destroyable"):
				self.add_to_group("hittable")

func _process(delta):
	if is_controlled:
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
