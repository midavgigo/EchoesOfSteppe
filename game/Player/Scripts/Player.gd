extends CharacterBody2D
#imports
const PlayerClass 		= preload("res://Player/Scripts/PlayerClass.gd")
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
var 	PLAYER_NAME 		= "main_player"
var 	hitting 			= false
var		shooting			= false
var		dodging				= false
var		dodging_time		= 0
var 	enemys 				= []
var 	debug_type 			= DebugType.PLAYER
var 	animation_status 	= AnimationStatus.STAND
#nodes
@onready var debug_label = $PlayerHud/DebugMessage
@onready var animation = $Animation
@onready var hpBar = $PlayerHud/pHpBar
@onready var weapon_anim = $PrimaryWeapon/WeaponAnimation
@onready var pweapon_area = $PrimaryWeapon
#inventory
var primary
var secondary
var slots

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

func mdir():
	var mouse = get_global_mouse_position()
	var spos = position
	if spos == mouse:
		return
	var mdir = mouse - spos
	return (mdir/mdir.length()).limit_length(1)

func hit():
	player.weapon_anim.visible = true
	player.weapon_anim.play("default")
	player.hitting = true

func shoot():
	pass
	
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
	if not dodging:
		player.set_joy(x, y)
	player.calc(delta*10)
	if Input.is_action_pressed("primary_weapon"):
		hit()
	if Input.is_action_pressed("secondary_weapon"):
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
	hpBar.set_hp(player.health)

#sysfuncs
func _ready():
	player = PlayerClass.new(PLAYER_NAME)
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
				debug_label.text = player.debug() + "\nposition: "+str(position)
			DebugType.WEAPON:
				debug_label.text = weapon.debug()
			DebugType.EQUIPMENT:
				debug_label.text = equipment.debug()
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
