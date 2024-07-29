extends Node2D

@onready var platform_scene = load("res://Scenes/Platform/Platform.tscn")

func generate():
	for x in range(10):
		for y in range(10):
			var platform = platform_scene.instantiate()
			platform.position.x = x*100
			platform.position.y = y*100
			if randi()%2:
				add_child(platform)

func _ready():
	generate()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var platforms = get_tree().get_nodes_in_group("platform")
		for i in platforms:
			i.queue_free()
		generate()
