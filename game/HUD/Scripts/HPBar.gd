extends Node2D

@onready var fill = $Flap

func _ready():
	pass

func set_hp(val):
	val = max(min(val, 1), 0)
	fill.scale.x = -1+val
