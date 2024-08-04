extends CharacterBody2D
var player
var weapon
var equipment
@onready var debug_label = $DebugMessage
@onready var animation = $Animation
@onready var hp_front = $HpFront
@onready var weapon_anim = $Area2D/WeaponAnimation
@onready var area = $Area2D
var PLAYER_NAME = "test_player"
var EQUIPMENT_NAME = "test_equipment"
var WEAPON_NAME = "test_weapon"
var hitting = false
var enemys = []

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
	weapon_anim.sprite_frames = load("res://Player/Animations/"+weapon.type+".tres")
	weapon_anim.set_speed_scale(weapon.speed/weapon_anim.sprite_frames.get_animation_speed("default")*weapon.speed_q)

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

func hit():
	weapon_anim.visible = true
	weapon_anim.play("default")
	hitting = true
	for i in enemys:
		match i.get_resist():
			"armor":
				i.hit(weapon.damage*weapon.armor, weapon.material)
			"flesh":
				i.hit(weapon.damage*weapon.flesh, weapon.material)
			"spirit":
				i.hit(weapon.damage*weapon.spirit, weapon.material)

func player_process(delta):
	var x = Input.get_action_strength("player_right")-Input.get_action_strength("player_left")
	var y = Input.get_action_strength("player_down")-Input.get_action_strength("player_up")
	if not hitting and not(x==0 and y==0):
		area.rotate(round(atan2(y, x)/PI*2)*PI/2 - area.rotation)
	player.set_joy(x, y)
	player.calc(delta*10)
	if Input.is_action_just_pressed("hit"):
		hit()
	velocity = player.get_velocity()
	move_and_slide()

func set_hit(damage, type):
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



func _on_weapon_animation_animation_finished():
	weapon_anim.visible = false
	hitting = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("hittable") and not hitting:
			enemys.append(body)


func _on_area_2d_body_exited(body):
	enemys.erase(body)
