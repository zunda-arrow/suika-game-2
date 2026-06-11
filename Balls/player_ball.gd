extends Ball

class_name PlayerBall

signal on_merge(size: int)

var disable_double_merge_s = .025
var merge_disabled_timer = 0

var r: FruitResouce.Fruit:
	set(val):
		if val == null:
			return
		r = val
		%Sprite.texture = val.texture
		set_texture()
	get():
		return r

func set_resource(re: FruitResouce):
	r = re.new()

func _ready() -> void:
	super._ready()
	add_to_group("player-balls")

func _physics_process(delta: float) -> void:
	merge_disabled_timer -= delta

	for body in self.get_colliding_bodies():
		collide_with_body(body)

	time_alive += delta
	
	$Sprite.position = global_position
	$Sprite.rotation = rotation

func flash():
	await get_tree().create_timer(.1).timeout

func collide_with_body(body: PhysicsBody2D):
	if not body.is_in_group("player-balls"):
		return
	if body.size != size:
		return
	if merge_disabled_timer > 0 or body.merge_disabled_timer > 0:
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
	
	merge_disabled_timer = disable_double_merge_s


func _on_on_size_change(old_size: int, new_size: int) -> void:
	set_texture()
	
func set_texture():
	var scale = float(get_radius() * 2) / float(%Sprite.texture.get_width())
	%Sprite.scale = Vector2(scale, scale)
