extends StaticBody2D

var title = ""
@onready var collision = $CollisionShape2D
var sprite = null
var on_action_collision = null
var block_controller = null
var can_action = false
var player = null

func hit(damage, material):
	block_controller.hit(damage, material)

func get_resist():
	return "none"

func _ready():
	title = self.get_meta("title")
	var file = FileAccess.open("res://Props/Configurations/blocks.json",FileAccess.READ)
	var dict = JSON.parse_string(file.get_as_text())
	match typeof(dict):
		TYPE_DICTIONARY:
			var width = dict[title]["width"]
			var height = dict[title]["height"]
			var raw_width = 0
			var raw_height = 0
			collision.shape.size.x = width
			collision.shape.size.y = height
			if dict[title]["animated"] == "true":
				sprite = AnimatedSprite2D.new()
				add_child(sprite)
				sprite.sprite_frames = load("res://Props/Animations/Blocks/"+title+".tres")
				raw_width = sprite.sprite_frames.get_frame_texture("default", 0).get_width()
				raw_height = sprite.sprite_frames.get_frame_texture("default", 0).get_height()
				sprite.play("default")
			else:
				sprite = Sprite2D.new()
				add_child(sprite)
				sprite.texture = load("res://Props/Sprites/Blocks/"+title+"/"+title+".png")
				raw_width = sprite.texture.get_width()
				raw_height = sprite.texture.get_height()
			sprite.transform = sprite.transform.scaled(Vector2(width/raw_width, height/raw_height))
			if dict[title]["script"] != "-":
				block_controller = load(dict[title]["script"]).new(self)
				if dict[title]["action_area"]["action"] == "true":
					on_action_collision = CollisionShape2D.new()
					var area = Area2D.new()
					area.add_child(on_action_collision)
					add_child(area)
					on_action_collision.shape = RectangleShape2D.new()
					on_action_collision.shape.size.x = dict[title]["action_area"]["width"]
					on_action_collision.shape.size.y = dict[title]["action_area"]["height"]
					area.body_entered.connect(_on_entered)
					area.body_exited.connect(_on_exited)
					var x = dict[title]["action_area"]["x"]
					var y = dict[title]["action_area"]["y"]
					on_action_collision.transform = on_action_collision.transform.translated(Vector2(x, y))
				if dict[title]["destroy_type"] != "none":
					self.add_to_group("hittable")
		
func _process(delta):
	block_controller.process(delta)
	if can_action && Input.is_action_just_pressed("action"):
		block_controller.action(player)

func _on_entered(body):
	if body.is_in_group("player"):
		can_action = true
		player = body

func _on_exited(body):
	if body.is_in_group("player"):
		can_action = false
