extends RigidBody2D
class_name Ball

signal on_size_change(old_size: int, new_size: int)

var is_ball = true
var size: int:
	get():
		return size
	set(val):
		size = val
		%Collision.shape.radius = get_radius()
		on_size_change.emit(size, val)
		
var time_alive = 0

func _ready() -> void:
	add_to_group("balls")
	%Collision.shape = %Collision.shape.duplicate()

func _physics_process(delta: float) -> void:
	time_alive += delta

func get_radius():
	return 10 + 20 * (1 + (float(size)))

func get_ball_scale():
	return (1 + (float(size)))
