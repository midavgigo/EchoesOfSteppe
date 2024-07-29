extends Node2D

@onready var count_text = $Count
@onready var status_text = $Status
@onready var animated_sprite = $AS2D

var count = 0

func _on_button_pressed():
	animated_sprite.play("animation")
	status_text.text = "Анимация проигрывается"

func _on_as_2d_animation_finished():
	count+=1
	count_text.text = str(count)
	status_text.text = "Анимация завершилась"
