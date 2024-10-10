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
var 	PLAYER_NAME 		= "demo_player"
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

func primary_weapon():
	weapon_anim.visible = true
	weapon_anim.play("default")
	hitting = true
	player.inventory.pweapon.attack()

func secondary_weapon():
	player.inventory.sweapon.attack()
	
func dodge():
	dodging = true
	
func player_process(delta):
	var x = Input.get_action_strength("player_right")-Input.get_action_strength("player_left")
	var y = Input.get_action_strength("player_down")-Input.get_action_strength("player_up")
	if not dodging:
		player.set_joy(x, y)
	player.calc(delta*10)
	if Input.is_action_pressed("primary_weapon"):
		primary_weapon()
	if Input.is_action_pressed("secondary_weapon"):
		secondary_weapon()
	if Input.is_action_just_pressed("dodge"):
		dodge()
	player.inventory.process(delta)
	velocity = player.get_velocity()
	if dodging:
		velocity *= 10
	move_and_slide()

func set_hit(damage, type):
	match type:
		"weapon":
			player.health -= damage*player.inventory.armor.weapon
		"beast":
			player.health -= damage*player.inventory.armor.beast
		"spirit":
			player.health -= damage*player.inventory.armor.spirit
	hpBar.set_hp(player.health)

#sysfuncs
func _ready():
	player = PlayerClass.new(self, PLAYER_NAME)
	animation.sprite_frames = load("res://Player/Animations/"+PLAYER_NAME+".tres")
	animation.animation = "Stand"
	animation.play("Stand")
	weapon_anim.sprite_frames = load("res://Item/Animations/"+player.inventory.pweapon.TYPE+".tres")
	
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
				debug_label.text = player.pweapon.debug()
			DebugType.EQUIPMENT:
				debug_label.text = player.armor.debug()
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
