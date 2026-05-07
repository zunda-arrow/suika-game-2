extends Ball

class_name PlayerBall

signal on_merge(size: int)

var r: FruitResouce:
	set(val):
		if val == null:
			return
		r = val
		%Sprite.texture = val.texture
	get():
		return r

func _ready() -> void:
	super._ready()
	add_to_group("player-balls")
	
	r = R.Fruits["default"]

func _physics_process(delta: float) -> void:	
	for body in self.get_colliding_bodies():
		collide_with_body(body)

	time_alive += delta

func flash():
	await get_tree().create_timer(.1).timeout

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


func _on_on_size_change(old_size: int, new_size: int) -> void:
	var scale = float(get_radius() * 2) / float(%Sprite.texture.get_width())
	%Sprite.scale = Vector2(scale, scale)
