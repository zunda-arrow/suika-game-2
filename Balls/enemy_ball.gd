extends Ball
class_name EnemyBall

var is_dead = false

func _physics_process(delta: float) -> void:
	time_alive += delta

func _ready() -> void:
	super._ready()
	add_to_group("enemy-ball")
	
	size = randi_range(1, 2)

func damage(n):
	if size - n < 0:
		is_dead = true
		queue_free()
		return
	
	var clone: Ball = duplicate()
	size -= n

	get_parent().add_child(clone)
	
	clone.linear_velocity.x -= 20
	clone.size = size
	linear_velocity.x += 20
	
