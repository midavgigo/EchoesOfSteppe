extends CharacterBody2D

const SPEED = 100

func _ready():
	velocity = velocity.limit_length(SPEED)

func _process(delta):
	var velocity_coef = [0, 0]
	if Input.is_action_pressed("player_left"):
		velocity_coef[0] = -1
	if Input.is_action_pressed("player_right"):
		velocity_coef[0] = 1
	if Input.is_action_pressed("player_up"):
		velocity_coef[1] = -1
	if Input.is_action_pressed("player_down"):
		velocity_coef[1] = 1
	velocity.x = velocity_coef[0]*SPEED
	velocity.y = velocity_coef[1]*SPEED
	move_and_slide()
