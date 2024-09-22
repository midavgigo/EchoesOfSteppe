extends Node2D

@onready var player = $Player

var passed_time = 0

func _process(delta):
	passed_time+=delta
	if passed_time > 0.5:
		passed_time = 0
		add_child(load("res://Enemy/Scenes/Smell.tscn").instantiate())
