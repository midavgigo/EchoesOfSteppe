extends CharacterBody2D
var player
var weapon
var equipment
@onready var debug_label = $DebugMessage
@onready var animation = $Animation
@onready var hp_front = $HpFront
var PLAYER_NAME = "test_player"
var EQUIPMENT_NAME = "test_equipment"
var WEAPON_NAME = "test_weapon"

enum AnimationStatus{
	STAND,
	WALK,
	DEAD
}

enum DebugType{
	PLAYER,
	WEAPON,
	EQUIPMENT
}

var debug_type = DebugType.PLAYER

var animation_status = AnimationStatus.STAND
func _ready():
	player = load("res://Player/Scripts/PlayerClass.gd").new(PLAYER_NAME)
	weapon = load("res://Player/Scripts/WeaponClass.gd").new(WEAPON_NAME)
	equipment = load("res://Player/Scripts/EquipmentClass.gd").new(EQUIPMENT_NAME)
	animation.sprite_frames = load("res://Player/Animations/"+PLAYER_NAME+".tres")
	animation.animation = "Stand"
	animation.play("Stand")

func analyze_anim():
	var temp = animation_status
	if velocity.length() < 30:
		temp = AnimationStatus.STAND
	else:
		temp = AnimationStatus.WALK
	if player.health <= 0.001:
		temp = AnimationStatus.DEAD
	if temp != animation_status:
		animation.stop()
		match temp:
			AnimationStatus.STAND:
				animation.play("Stand")
			AnimationStatus.WALK:
				animation.play("Walk")
			AnimationStatus.DEAD:
				animation.play("Dead")
	animation_status = temp

func player_process(delta):
	player.set_joy(
		Input.get_action_strength("player_right")-Input.get_action_strength("player_left"), 
		Input.get_action_strength("player_down")-Input.get_action_strength("player_up")
	)
	player.calc(delta*10)
	velocity = player.get_velocity()
	move_and_slide()

func hit(damage, type):
	match type:
		"weapon":
			player.health -= damage*equipment.weapon
		"beast":
			player.health -= damage*equipment.beast
		"spirit":
			player.health -= damage*equipment.spirit

func _process(delta):
	analyze_anim()
	debug_label.text = ""
	var debug_full = false
	if Input.is_action_pressed("ui_accept"):
		debug_full = true
	if Input.is_action_just_pressed("change_debug"):
		debug_type = (debug_type+1)%DebugType.values().size()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if debug_full:
		match debug_type:
			DebugType.PLAYER:
				debug_label.text = player.debug()
			DebugType.WEAPON:
				debug_label.text = weapon.debug()
			DebugType.EQUIPMENT:
				debug_label.text = equipment.debug()
	hp_front.scale.x = minf(1-player.health, 1)
	if player.health > 0.001:
		player_process(delta)
