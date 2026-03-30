extends Node2D

var ball = preload("res://Balls/PlayerBall.tscn")
var enemy_ball = preload("res://Balls/EnemyBall.tscn")

var enemies = []
var turn_queue = []
var turn_number = 1

var score: int:
	set(val):
		score = val
		%Score.text = "Score:" + str(val)
	get():
		return score

var waiting_for_turn_to_end = true

func _ready() -> void:
	for i in range(3):
		end_turn()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		if turn_queue[0] != EnemyQueueOptions.Player:
			return
		if waiting_for_turn_to_end:
			return

		waiting_for_turn_to_end = true
		turn_queue.pop_at(0)
		%TurnQueue.dispay_turns(turn_queue)
		
		var x = get_global_mouse_position().x
		if x < 550:
			x = 550
		if x > 1200:
			x = 1200
		
		var y = 100
		
		var b: PlayerBall = ball.instantiate()
		$Balls.add_child(b)
		b.position = Vector2(x, y)
		b.on_merge.connect(func(size):
			on_merge(b, size)
		)


func spawn_enemy():
	var x = randi_range(550, 1200)
	var y = 100
	
	var b = enemy_ball.instantiate()
	$Balls.add_child(b)
	b.position = Vector2(x, y)
	
	enemies.push_back(b)

func on_merge(ball, size):
	if len(enemies) == 0:
		return

	score += 15 + (size - 1) * 5

	var closest = 0
	
	for i in range(len(enemies)):
		var d1 = (enemies[closest].position - ball.position).length()
		var d2 = (enemies[i].position - ball.position).length()
	
		if d2 < d1:
			closest = i
	
	enemies[closest].damage(1)
	score += 5

	if enemies[closest].size < 0:
		enemies[closest].queue_free()
		enemies.pop_at(closest)
		
		


func _process(_delta: float) -> void:
	position_ball_marker()
	
	var should_end_turn = true
	if waiting_for_turn_to_end:
		for b: RigidBody2D in $Balls.get_children():
			if b.time_alive < .6:
				should_end_turn = false
				break
			
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
	
	if next == EnemyQueueOptions.Eneny:
		turn_queue.pop_at(0)
		spawn_enemy()
		%TurnQueue.dispay_turns(turn_queue)
		waiting_for_turn_to_end = true

func end_turn():
	turn_number += 1
	if turn_number % 4 == 0:
		add_new_enemy_to_queue()
	else:
		add_player_to_queue()

func add_new_enemy_to_queue():
	turn_queue.push_back(EnemyQueueOptions.Eneny)
	%TurnQueue.dispay_turns(turn_queue)

func add_player_to_queue():
	turn_queue.push_back(EnemyQueueOptions.Player)
	%TurnQueue.dispay_turns(turn_queue)


func position_ball_marker():
	var highest_ball: Ball = null

	for b: Ball in $Balls.get_children():
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
