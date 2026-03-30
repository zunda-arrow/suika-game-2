extends Ball
class_name EnemyBall

func _physics_process(delta: float) -> void:
	time_alive += delta

func _ready() -> void:
	add_to_group("enemy-ball")
	
	size = randi_range(2, 3)
	%Collision.shape.radius = get_radius()

func damage(n):
	size -= n
	%Collision.shape.radius = get_radius()

	if size < 0:
		queue_free()
