extends Area2D


func _on_body_entered(body):
	body.hit(0.1, "beast")
