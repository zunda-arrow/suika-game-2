extends RigidBody2D

class_name EnemyBall

signal on_merge(size: int)

var is_ball = true
var size = 0
var time_alive = 0

func _physics_process(delta: float) -> void:
	time_alive += delta

func _ready() -> void:
	add_to_group("enemy-ball")
	%Collision.shape = %Collision.shape.duplicate()
	
	size = randi_range(2, 3)
	%Collision.shape.radius = 20 * (1 + (float(size)))

func damage(n):
	size -= n
	%Collision.shape.radius = 20 * (1 + (float(size)))

	if size < 0:
		queue_free()
