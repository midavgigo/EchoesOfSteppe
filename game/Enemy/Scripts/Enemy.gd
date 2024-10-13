extends CharacterBody2D

const EnemyClass = preload("res://Enemy/Scripts/EnemyClass.gd")

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var weapon = $Area2D/AnimatedSprite2D

var enemy
var title
var player
var smells
var target 

var dead = false
var can_hit = false
var passed_time = 0

func get_target():
	var space_state = get_world_2d().direct_space_state
	for i in smells:
		if i == null:
			continue
		var query = PhysicsRayQueryParameters2D.create(position, i.position)
		query.exclude = [self, player]
		var result = space_state.intersect_ray(query)
		if not result:
			target = i
			return true
	target = null
	return false

func aggressive():
	enemy.set_target(position, target.position)

func tactic():
	if target.freshness > 0:
		enemy.set_target(position, target.position)
	else:
		var position_target:Vector2 = position-target.position
		position_target *= enemy.attack.distance/position_target.length() 
		position_target += target.position
		enemy.set_target(position, position_target)

func _ready():
	title = get_meta("title")
	enemy = EnemyClass.new(self, title)
	if enemy.is_boss:
		player = get_tree().get_nodes_in_group("player")[0]
		player.hud.bHpBar.visible = true
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
		area.rotate(atan2(y, x) - area.rotation)

func melee(delta):
	if can_hit:
		if passed_time > enemy.attack.data:
			weapon.visible = true
			weapon.play("default")
			player.set_hit(enemy.attack.damage, enemy.attack.type)
			passed_time = 0
	if passed_time < enemy.attack.data:
		passed_time += delta*1000

func _process(delta):
	if enemy.health <= 0:
		sprite.play("Death")
		dead = true
		return 
	enemy.calc(delta)
	call(enemy.attack.style, delta)
	var temp = get_tree().get_nodes_in_group("smell")
	smells = []
	for i in range(16):
		smells.append(null)
	for i in temp:
		smells[i.freshness] = i	
	if get_target():
		call(enemy.movement.pattern)
	else:
		enemy.stop()
	speed_analyze()
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		can_hit = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		can_hit = false

func _on_animated_sprite_2d_animation_finished():
	weapon.visible = false

func get_resist():
	return enemy.resist

func set_hit(damage, material):
	enemy.set_hit(damage, material)
	if enemy.is_boss:
		player.hud.bHpBar.set_val(enemy.health, enemy.max_health)

func _enemy_animation_end():
	if dead:
		player.hud.bHpBar.visible = false
		queue_free()

func add_effect(name, value):
	for i in enemy.effects:
		if i.NAME == name:
			i.add_value(value)
			return
	enemy.effects.append(load("res://Tools/Scripts/Effects/"+name+".gd").new(self, value))


func _on_collide(body):
	enemy.collide(body)
