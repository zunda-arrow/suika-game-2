extends Ball

class_name PlayerBall

signal on_merge(size: int)

func _ready() -> void:
	super._ready()
	add_to_group("player-balls")
	%Collision.shape = %Collision.shape.duplicate()


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

	position = new_pos
	size += 1

	body.queue_free()
	on_merge.emit(size)
