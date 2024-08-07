extends Area2D

var title = ""
@onready var collision = $CollisionShape2D
var sprite = null

var actionable = false
var floor_controller = null
var can_action = false
var player = null

func _ready():
	title = self.get_meta("title")
	var file = FileAccess.open("res://Props/Configurations/floors.json",FileAccess.READ)
	var dict = JSON.parse_string(file.get_as_text())
	match typeof(dict):
		TYPE_DICTIONARY:
			var width = dict[title]["width"]
			var height = dict[title]["height"]
			var raw_width = 0
			var raw_height = 0
			if dict[title]["animated"] == "true":
				sprite = AnimatedSprite2D.new()
				add_child(sprite)
				sprite.sprite_frames = load("res://Props/Animations/Floors/"+title+".tres")
				raw_width = sprite.sprite_frames.get_frame_texture("default", 0).get_width()
				raw_height = sprite.sprite_frames.get_frame_texture("default", 0).get_height()
				sprite.play("default")
			else:
				sprite = Sprite2D.new()
				add_child(sprite)
				sprite.texture = load("res://Props/Sprites/Floors/"+title+"/"+title+".png")
				raw_width = sprite.texture.get_width()
				raw_height = sprite.texture.get_height()
			sprite.transform = sprite.transform.scaled(Vector2(width/raw_width, height/raw_height))
			collision.shape.size.x = width
			collision.shape.size.y = height
			if dict[title]["script"]!="-":
				floor_controller = load(dict[title]["script"]).new(self)
			if dict[title]["actionable"]=="true":
				actionable = true

func _process(delta):
	if actionable && can_action && Input.is_action_just_pressed("action"):
		floor_controller.action(player)

func _on_body_entered(body):
	if floor_controller != null:
		floor_controller.on_entered(body)
		if body.is_in_group("player"):
			can_action = true
			player = body



func _on_body_exited(body):
	if floor_controller != null:
		floor_controller.on_exited(body)
		if body.is_in_group("player"):
			can_action = false
