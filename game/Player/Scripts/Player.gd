extends CharacterBody2D
#imports
const PlayerClass 		= preload("res://Player/Scripts/PlayerClass.gd")
const WeaponClass 		= preload("res://Player/Scripts/WeaponClass.gd")
const EquipmentClass 	= preload("res://Player/Scripts/EquipmentClass.gd")
#scenes
const Missile			= preload("res://Missile/Scenes/test/test_missile.tscn")
#enums
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
#consts
const	DODGE_LIMIT			= 125
#vars
var 	player
var 	weapon
var 	equipment
var 	PLAYER_NAME 		= "test_player"
var 	EQUIPMENT_NAME 		= "test_equipment"
var 	WEAPON_NAME 		= "test_weapon"
var 	hitting 			= false
var		dodging				= false
var		dodging_time		= 0
var 	enemys 				= []
var 	debug_type 			= DebugType.PLAYER
var 	animation_status 	= AnimationStatus.STAND
#nodes
@onready var debug_label = $DebugMessage
@onready var animation = $Animation
@onready var hp_front = $HpFront
@onready var weapon_anim = $Area2D/WeaponAnimation
@onready var area = $Area2D

#funcs
func is_dead():
	return player.health <= 0.001

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
			"none":
				i.hit(weapon.damage, weapon.material)

func shoot():
	var mouse = get_global_mouse_position()
	var spos = position
	var missile = Missile.instantiate()
	missile.position = position
	get_tree().root.add_child(missile)
	for i in get_tree().root.get_children():
		if i == missile:
			i.get_child(0).initialize((((mouse-spos)*300).limit_length(300)), true)
			break

func dodge():
	dodging = true
	
func player_process(delta):
	if dodging:
		dodging_time += delta*1000
	if dodging_time >= DODGE_LIMIT:
		dodging = false
		dodging_time = 0
	var x = Input.get_action_strength("player_right")-Input.get_action_strength("player_left")
	var y = Input.get_action_strength("player_down")-Input.get_action_strength("player_up")
	if not hitting:
		var mouse_dir = get_global_mouse_position()-position
		area.rotate(atan2(mouse_dir.y, mouse_dir.x)- area.rotation)
	if not dodging:
		player.set_joy(x, y)
	player.calc(delta*10)
	if Input.is_action_just_pressed("primary_weapon"):
		hit()
	if Input.is_action_just_pressed("secondary_weapon"):
		#TODO: Переименовать функцию и сделать проверку типа атаки
		shoot()
	if Input.is_action_just_pressed("dodge"):
		dodge()
	velocity = player.get_velocity()
	if dodging:
		velocity *= 10
	move_and_slide()

func set_hit(damage, type):
	match type:
		"weapon":
			player.health -= damage*equipment.weapon
		"beast":
			player.health -= damage*equipment.beast
		"spirit":
			player.health -= damage*equipment.spirit

#sysfuncs
func _ready():
	player = PlayerClass.new(PLAYER_NAME)
	weapon = WeaponClass.new(WEAPON_NAME)
	equipment = EquipmentClass.new(EQUIPMENT_NAME)
	animation.sprite_frames = load("res://Player/Animations/"+PLAYER_NAME+".tres")
	animation.animation = "Stand"
	animation.play("Stand")
	weapon_anim.sprite_frames = load("res://Player/Animations/"+weapon.type+".tres")
	weapon_anim.set_speed_scale(weapon.speed/weapon_anim.sprite_frames.get_animation_speed("default")*weapon.speed_q)

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
	if !is_dead():
		player_process(delta)

func _on_weapon_animation_animation_finished():
	weapon_anim.visible = false
	hitting = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("hittable") and not hitting:
			enemys.append(body)

func _on_area_2d_body_exited(body):
	enemys.erase(body)

func is_player_action():
	return !is_dead() && Input.is_action_just_pressed("action")
