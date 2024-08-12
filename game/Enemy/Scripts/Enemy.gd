extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D

var enemy
var title
var player
var smells
var target 

var can_hit = false
var passed_time = 0

func aggressive():
	var space_state = get_world_2d().direct_space_state
	var no_smell = true
	for i in smells:
		if i == null:
			continue
		var query = PhysicsRayQueryParameters2D.create(position, i.position)
		query.exclude = [self, player]
		var result = space_state.intersect_ray(query)
		if not result:
			enemy.set_target(position, i.position)
			target = i
			no_smell = false
			break
	if no_smell:
		target = null
		enemy.stop()

func tactic():
	pass

func scared():
	pass

func _ready():
	title = get_meta("title")
	enemy = load("res://Enemy/Scripts/EnemyClass.gd").new(title)
	sprite.sprite_frames = load("res://Enemy/Animations/"+title+".tres")
	sprite.animation = "Stand"
	sprite.play("Stand")
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func speed_analyze():
	velocity = enemy.get_velocity()
	if velocity.length() >= 30:
		sprite.play("Walk")
	else:
		sprite.play("Stand")
	var norm_velocity = velocity.normalized()
	var x = norm_velocity.x
	var y = norm_velocity.y
	if not(x==0 and y==0):
		area.rotate(round(atan2(y, x)/PI*2)*PI/2 - area.rotation)


func attack(delta):
	if can_hit:
		if passed_time == 0:
			player.set_hit(enemy.attack.damage, enemy.attack.type)
		passed_time += delta
		if passed_time > enemy.attack.data:
			passed_time = 0
	else:
		passed_time = 0

func _process(delta):
	var temp = get_tree().get_nodes_in_group("smell")
	smells = []
	for i in range(16):
		smells.append(null)
	for i in temp:
		smells[i.freshness] = i	
	call(enemy.movement.pattern)
	enemy.calc(delta)
	speed_analyze()
	move_and_slide()
	attack(delta)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		can_hit = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		can_hit = false
