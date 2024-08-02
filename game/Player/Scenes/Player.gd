extends CharacterBody2D
var player
@onready var debug_label = $DebugMessage
@onready var animation = $Animation

enum AnimationStatus{
	STAND,
	WALK,
	RUN
}

var animation_status = AnimationStatus.STAND
func _ready():
	player = load("res://Player/Scripts/PlayerClass.gd").new("res://Player/Configurations/players/test_player.json")

func analyze_anim():
	var temp = animation_status
	if velocity.length() < 30:
		temp = AnimationStatus.STAND
	else:
		if player.is_run():
			temp = AnimationStatus.RUN
		else:
			temp = AnimationStatus.WALK
	if temp != animation_status:
		animation.stop()
		match temp:
			AnimationStatus.STAND:
				animation.play("Stand")
			AnimationStatus.WALK:
				animation.play("Walk")
			AnimationStatus.RUN:
				animation.play("Run")
	animation_status = temp

func _process(delta):
	player.set_run(false)
	if Input.is_action_pressed("run"):
		player.set_run(true)
	player.set_joy(
		Input.get_action_strength("player_right")-Input.get_action_strength("player_left"), 
		Input.get_action_strength("player_down")-Input.get_action_strength("player_up")
	)
	analyze_anim()
	player.calc(delta*10)
	velocity = player.get_velocity()
	move_and_slide()
