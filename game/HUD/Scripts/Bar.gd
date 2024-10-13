extends Node2D

@onready var fill = $Flap

func _ready():
	pass

func set_val(val, max = 1):
	val /= max
	val = max(min(val, 1), 0)
	fill.scale.x = val-1
