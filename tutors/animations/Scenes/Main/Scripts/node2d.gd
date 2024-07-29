extends Node2D

@onready var animated_sprite = $AS2D

var play = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		play = not play
	if play:
		animated_sprite.play("animation")
	else:
		animated_sprite.stop()
