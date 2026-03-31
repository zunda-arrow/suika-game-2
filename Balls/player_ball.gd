extends Ball

class_name PlayerBall

signal on_merge(size: int)

func _ready() -> void:
	super._ready()
	add_to_group("player-balls")


func _physics_process(delta: float) -> void:	
	for body in self.get_colliding_bodies():
		collide_with_body(body)

	time_alive+= delta


func collide_with_body(body: PhysicsBody2D):
	if not body.is_in_group("player-balls"):
		return
	if body.size != size:
		return

	var new_pos = (position + body.position) / 2
	var new_velocity = (linear_velocity + body.linear_velocity) / 2
	var new_ang_vel = (angular_velocity + body.angular_velocity) / 2

	position = new_pos
	linear_velocity = new_velocity
	angular_velocity = new_ang_vel
	
	size += 1

	body.queue_free()
	on_merge.emit(size)
