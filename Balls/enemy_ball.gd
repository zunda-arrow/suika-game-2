extends Ball
class_name EnemyBall

var floating_text = preload("res://game/FloatingText.tscn")

var is_dead = false
var health = 1:
	set(val):
		health = val
		$Health.text = str(health)
	get():
		return health

func _physics_process(delta: float) -> void:
	time_alive += delta

func _ready() -> void:
	super._ready()
	add_to_group("enemy-ball")
	size = randi_range(1, 2)
	
	health = 2 ** size

func damage(n):
	var text = floating_text.instantiate()
	
	get_parent().get_parent().add_child(text)
	text.set_damage_number(n)
	text.global_position = global_position
	
	health -= n
	if health > 0:
		return
	
	if size <= 0:
		is_dead = true
		queue_free()
		return
	
	var clone: Ball = duplicate()
	get_parent().add_child(clone)

	size -= 1
	clone.size = size

	# When we clone, we need to set all the values which is hard
	# This will need to be picked by the stage or something
	health = 2 ** size
	clone.health = 2 ** size

	clone.linear_velocity.x -= 50
	linear_velocity.x += 50
	clone.linear_velocity.y -= 50
	linear_velocity.y -= 50
