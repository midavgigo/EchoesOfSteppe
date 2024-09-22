extends Node2D

var freshness = 0
var MAX_FRESHNESS = 15
var passed_time = 0
var MAX_TIME_DIF = 0.5
var binded_body:CharacterBody2D = null

func _ready():
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0:
		binded_body = player[0]

func _process(delta):
	passed_time += delta
	if passed_time > MAX_TIME_DIF:
		passed_time = 0
		freshness += 1
		if freshness == 1:
			binded_body = null
		if freshness > MAX_FRESHNESS:
			queue_free()
	if binded_body != null:
		position = binded_body.position
