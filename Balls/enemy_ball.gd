extends Ball
class_name EnemyBall

func _physics_process(delta: float) -> void:
	time_alive += delta

func _ready() -> void:
	super._ready()
	add_to_group("enemy-ball")
	
	size = randi_range(3, 4)

func damage(n):
	size -= n
