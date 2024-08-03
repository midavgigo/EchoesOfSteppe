extends Area2D


func _on_body_entered(body):
	body.player.health -= 0.1
