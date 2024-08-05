extends Area2D

var title = ""
@onready var collision = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D

var floor_controller = null

func _ready():
	title = self.get_meta("title")
	var file = FileAccess.open("res://Props/Configuration/floors.json",FileAccess.READ)
	var dict = JSON.parse_string(file.get_as_text())
	match typeof(dict):
		TYPE_DICTIONARY:
			sprite.sprite_frames = load("res://Props/Animations/"+title+".tres")
			sprite.play("default")
			collision.shape.size.x = dict[title]["width"]
			collision.shape.size.y = dict[title]["height"]
			if dict[title]["script"]!="-":
				floor_controller = load(dict[title]["script"]).new()


func _on_body_entered(body):
	if floor_controller != null:
		floor_controller.stay_on_event(body)
		

