extends Area2D

var bod = null

func _on_body_exited(body):
	bod = null

func _on_body_entered(body):
	bod = body
	
var sum = 0
	
func _process(delta):
	sum += delta
	if sum >= 0.1:
		if bod != null:
			bod.set_hit(0.1, "beast")
		sum = 0
		

