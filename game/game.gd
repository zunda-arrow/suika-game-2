extends Node2D

var ball = preload("res://game/Ball.tscn")
var enemy_ball = preload("res://game/EnemyBall.tscn")

var enemies = []
var turn_queue = []
var turn_number = 1

var waiting_for_turn_to_end = false

func _ready() -> void:
	for i in range(4):
		end_turn()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		if turn_queue[0] != EnemyQueueOptions.Player:
			return

		waiting_for_turn_to_end = true
		turn_queue.pop_at(0)
		
		var x = get_global_mouse_position().x
		if x < 550:
			x = 550
		if x > 1200:
			x = 1200
		
		var y = 100
		
		var b: Ball = ball.instantiate()
		$Balls.add_child(b)
		b.position = Vector2(x, y)
		
		b.on_merge.connect(on_merge)


func spawn_enemy():
	var x = randi_range(550, 1200)
	var y = 100
	
	var b = enemy_ball.instantiate()
	$Balls.add_child(b)
	b.position = Vector2(x, y)
	
	enemies.push_back(b)

func on_merge(size):
	if len(enemies) == 0:
		return
	var i = range(len(enemies)).pick_random()
	enemies[i].damage(1)

	if enemies[i].size < 0:
		enemies.remove_at(i)

func _process(_delta: float) -> void:
	var should_end_turn = true
	if waiting_for_turn_to_end:
		for b: RigidBody2D in $Balls.get_children():
			if b.time_alive < .2:
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
