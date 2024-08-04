extends CharacterBody2D

@onready var label = $Label

var last_call = Time.get_unix_time_from_system()

var resist = "armor"

func get_resist():
	return resist

func hit(damage, material):
	rotate(0.01)
	label.text = str(damage)
	last_call = Time.get_unix_time_from_system()


func _process(delta):
	var cur_call = Time.get_unix_time_from_system()
	if cur_call - last_call > 1:
		label.text = ""
