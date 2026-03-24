extends Node2D

var ball = preload("res://game/Ball.tscn")
var enemy_ball = preload("res://game/EnemyBall.tscn")

var enemies = []


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		var x = get_global_mouse_position().x
		var y = 100
		
		var b: Ball = ball.instantiate()
		add_child(b)
		b.position = Vector2(x, y)
		
		b.on_merge.connect(on_merge)
		

	if event.is_action_pressed("rightclick"):
		var x = get_global_mouse_position().x
		var y = 100
		
		var b = enemy_ball.instantiate()
		add_child(b)
		b.position = Vector2(x, y)
		
		enemies.push_back(b)

func on_merge(size):
	if len(enemies) == 0:
		return
	var i = range(len(enemies)).pick_random()
	enemies[i].damage(1)
	
	if enemies[i].size < 0:
		enemies.remove_at(i)
