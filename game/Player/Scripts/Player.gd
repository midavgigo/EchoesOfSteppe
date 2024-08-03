extends CharacterBody2D
var player
@onready var debug_label = $DebugMessage
@onready var animation = $Animation

enum AnimationStatus{
	STAND,
	WALK
}

var animation_status = AnimationStatus.STAND
func _ready():
	player = load("res://Player/Scripts/PlayerClass.gd").new("test_player")

func analyze_anim():
	var temp = animation_status
	if velocity.length() < 30:
		temp = AnimationStatus.STAND
	else:
		temp = AnimationStatus.WALK
	if temp != animation_status:
		animation.stop()
		match temp:
			AnimationStatus.STAND:
				animation.play("Stand")
			AnimationStatus.WALK:
				animation.play("Walk")
	animation_status = temp

func _process(delta):
	player.set_joy(
		Input.get_action_strength("player_right")-Input.get_action_strength("player_left"), 
		Input.get_action_strength("player_down")-Input.get_action_strength("player_up")
	)
	if Input.is_action_pressed("ui_accept"):
		player.set_joy(1, 0)
	analyze_anim()
	player.calc(delta*10)
	velocity = player.get_velocity()
	move_and_slide()
