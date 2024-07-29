extends Node2D

@onready var platform_scene = load("res://Scenes/Platform/Platform.tscn")

func _ready():
	for x in range(10):
		for y in range(10):
			var platform = platform_scene.instantiate()
			platform.position.x = x*100
			platform.position.y = y*100
			if randi()%2:
				add_child(platform)
