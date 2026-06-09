extends Node2D

class_name Game

var ball = preload("res://Balls/PlayerBall.tscn")
var enemy_ball = preload("res://Balls/EnemyBall.tscn")
var AttackScene = preload("res://Balls/Attack.tscn")

var turn_queue = []
var turn_number = 1

var required_score = 100

var currently_picked_upgrade = null

var score: int:
	set(val):
		score = val
		%Score.text = "Score:" + str(val) + "/" + str(required_score)
		%ScoreBar.value = float(val) / float(required_score)
		
		if score >= required_score:
			after_score_capped_reached()
	get():
		return score

var waiting_for_turn_to_end = true

func _ready() -> void:
	for i in range(2):
		end_turn()
	
	for item_box in [
		%Upgrade1,
		%Upgrade2,
		%Upgrade3,
		%Upgrade4,
		%Upgrade5,
	]:
		item_box.connect("item_dropped", func():
			drop_item(item_box, "fruit")
		)

func drop_item(item_box, t):
	var upgrade = currently_picked_upgrade
	if upgrade == null:
		return
	currently_picked_upgrade = null
	
	if t == "fruit" and upgrade.item_type == upgrade.ItemType.Fruit:
		item_box.set_resource(upgrade.fruit_resource)
		
	for fruit in $Balls.get_children():
		# This code definitely forces fruits to be stateless
		# But that should be a requirement anyway
		fruit.r = get_fruit_resource(fruit.size).new()
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		var x = get_global_mouse_position().x
		if x < %Left.position.x:
			return
		if x > %Right.position.x:
			return
		
		if turn_queue[0] not in [
			TurnQueueOptions.Fruit0,
			TurnQueueOptions.Fruit1,
		]:
			return

		if waiting_for_turn_to_end:
			return

		waiting_for_turn_to_end = true
		var fruit = turn_queue.pop_at(0)
		%TurnQueue.dispay_turns(turn_queue)

		var y = 100
		
		var b: PlayerBall = ball.instantiate()
		$Balls.add_child(b)
		b.position = Vector2(x, y)
		b.on_merge.connect(func(size):
			_on_merge(b, size)
		)
		
		if fruit == TurnQueueOptions.Fruit0:
			b.size = 0
			b.r = get_fruit_resource(0).new()
		if fruit == TurnQueueOptions.Fruit1:
			b.size = 1
			b.r = get_fruit_resource(1).new()

func get_fruits():
	return $Balls.get_children()

func get_shrooms():
	return $EnemyBalls.get_children()

func spawn_enemy():
	var x = randi_range(%Left.position.x, %Right.position.x)
	var y = 100
	
	var b = enemy_ball.instantiate()
	$EnemyBalls.add_child(b)
	b.position = Vector2(x, y)

func _on_merge(b: PlayerBall, size: int):
	b.r = get_fruit_resource(size).new()
	
	await create_attack_from_fruit(b)

	for fruit: PlayerBall in get_fruits():
		await fruit.r.behavior.passive(self, fruit)
	
	return
	
	# Make all of the fruits attack
	
	var has_attacked = [b]
	
	while true:
		var balls = get_fruits().filter(func(a):
			return a not in has_attacked
		)

		if len(balls) == 0:
			return
		
		var sort = func(a: PlayerBall, b: PlayerBall):
			return b.position.distance_to(a.position) > b.position.distance_to(b.position)

		balls.sort_custom(sort)
		var ball = balls[0]

		has_attacked.push_back(ball)

		if ball == null:
			continue
		if ball == b:
			continue
		await create_attack_from_fruit(ball)

func create_attack_from_fruit(b: PlayerBall):
	b.flash()
	
	var enemies = get_shrooms()
	
	if len(enemies) == 0:
		return

	score += 15 + (b.size - 1) * 5

	var weakest = 0
	var strongest = 0
	
	for i in range(len(enemies)):
		if enemies[i].size < enemies[weakest].size:
			weakest = i
		if enemies[i].size > enemies[strongest].size:
			strongest = i
	
	var d = BaseDamage.get_damage(b.size) ** 2

	var target
	if b.r.target_type == FruitResouce.FruitTarget.Random:
		target = enemies.pick_random()
	if b.r.target_type == FruitResouce.FruitTarget.Strongest:
		target = enemies[strongest]
	if b.r.target_type == FruitResouce.FruitTarget.Weakest:
		target = enemies[weakest]

	score += 5
	
	var attack = AttackScene.instantiate()
	attack.one_shot = true
	%AttackParticles.add_child(attack)
	attack.position = b.global_position
	attack.aim_at = target
	await attack.hit_the_target

	if target != null:
		target.damage(d)
	
func _process(_delta: float) -> void:
	position_ball_marker()
	update_attack_particles()
	
	var should_end_turn = true
	var are_all_stopped = true
	if waiting_for_turn_to_end:
		for b: RigidBody2D in get_fruits():
			if b.time_alive < .5:
				should_end_turn = false
			if b.linear_velocity.length() > .3 or b.time_alive < .5:
				are_all_stopped = false
		
		if are_all_stopped:
			should_end_turn = true

		if should_end_turn == true:
			waiting_for_turn_to_end = false
			print("ending turn")
			end_turn()

	if not waiting_for_turn_to_end:
		during_turn()

func during_turn():
	if waiting_for_turn_to_end:
		return

	var next = turn_queue[0]
	
	if next == TurnQueueOptions.Eneny:
		turn_queue.pop_at(0)
		spawn_enemy()
		%TurnQueue.dispay_turns(turn_queue)
		waiting_for_turn_to_end = true

func end_turn():
	turn_number += 1
	if turn_number % 2 == 0:
		add_new_enemy_to_queue()
	else:
		add_player_to_queue()

func add_new_enemy_to_queue():
	turn_queue.push_back(TurnQueueOptions.Eneny)
	%TurnQueue.dispay_turns(turn_queue)

func add_player_to_queue():
	var p = TurnQueueOptions.Fruit0
	
	if randi_range(0, 2) == 0:
		p = TurnQueueOptions.Fruit1
	
	turn_queue.push_back(p)
	%TurnQueue.dispay_turns(turn_queue)


func position_ball_marker():
	var highest_ball: Ball = null

	for b: Ball in get_fruits():
		var r = b.get_radius()
		
		if abs(b.position.x - get_local_mouse_position().x) < r:
			if highest_ball == null:
				highest_ball = b
			if b.position.y > highest_ball.position.y:
				highest_ball = b 


	var highest_pos = Vector2(get_local_mouse_position().x, 931 - 26)
	var radius = 1
	if highest_ball != null:
		radius = highest_ball.get_radius()
		highest_pos = highest_ball.position

	var x = get_local_mouse_position().x
	var y = (radius ** 2 - (get_local_mouse_position().x - highest_pos.x) ** 2) ** .5
	
	$Pointer.position = Vector2(x, highest_pos.y - y)

func after_score_capped_reached():
	score = 0
	# Show shop
	%Shop.show()

func get_fruit_resource(n):
	if n == 0:
		return %Upgrade1.get_resource()
	if n == 1:
		return %Upgrade2.get_resource()
	if n == 2:
		return %Upgrade3.get_resource()
	if n == 3:
		return %Upgrade4.get_resource()
	if n == 4:
		return %Upgrade5.get_resource()

func update_attack_particles():
	# If a particle loses a target, right now we will pick a new one
	# This needs to be redone to retarget properly, somehow
	for particle in %AttackParticles.get_children():
		if particle.aim_at == null:
			particle.aim_at = $EnemyBalls.get_children().pick_random()


func _on_shop_upgrade_picked(shop_item) -> void:
	currently_picked_upgrade = shop_item
