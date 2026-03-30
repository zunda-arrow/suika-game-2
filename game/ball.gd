extends RigidBody2D

class_name Ball

signal on_merge(size: int)

var is_ball = true
var size = 0
var time_alive = 0

func _ready() -> void:
	add_to_group("balls")
	%Collision.shape = %Collision.shape.duplicate()


func _physics_process(delta: float) -> void:
	for body in self.get_colliding_bodies():
		collide_with_body(body)

	time_alive += delta


func collide_with_body(body: PhysicsBody2D):
	if not body.is_in_group("balls"):
		return
	if body.size != size:
		return
		
	var new_pos = (position + body.position) / 2

	position = new_pos
	size += 1
	%Collision.shape.radius = 20 * (1 + (float(size)))

	body.queue_free()
	on_merge.emit(size)
	
