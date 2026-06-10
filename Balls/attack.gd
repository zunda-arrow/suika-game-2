@tool
extends Node2D

@export var aim_at: Node2D

@export var particle_gravity = -9.8
@export var speed = 500
@export var one_shot = true

@export var pixel_speed = 10

var one_shot_and_hit_the_target = false

signal hit_the_target

var projectile_percent = 0

func _process(delta: float) -> void:
	if one_shot_and_hit_the_target:
		queue_free()
		return

	if projectile_percent > 1:
		if one_shot:
			one_shot_and_hit_the_target = true
			hide()
		hit_the_target.emit()
		projectile_percent = 0

	if aim_at == null:
		# If there is nobody to aim at, give up
		# Wait for game to give new target
		return
	var end = aim_at.global_position - self.global_position

	$Path2D.curve.set_point_position(1, end)
	
	var x = end.x - 0
	var y = end.y - 0
	var g = particle_gravity
	var a = -g * (x ** 2) / speed
	var a_arrival = -g * (end.x ** 2) / speed
	var tan_launch = -x + sqrt(x ** 2 + 4 * a * (y + a)) / (2 * a)
	var launch = atan(tan_launch)
	var tan_arrival = -end.x + sqrt(end.x ** 2 + 4 * a_arrival * (y + a_arrival)) / (2 * a_arrival)
	var arrival = atan(tan_arrival)
	
	var flip = 1
	if end.x < 0:
		flip = -1
	
	$Path2D.curve.set_point_out(0, Vector2i(cos(launch) * speed,sin(launch) * speed * flip))
	$Path2D.curve.set_point_in(1, Vector2i(cos(arrival) * speed,sin(arrival) * speed * flip))
	
	var points = PackedVector2Array()
	var curve: Curve2D = $Path2D.get_curve()
	var end_point = curve.sample(0, projectile_percent)

	var length = curve.get_baked_length()
	var multiplier = pixel_speed / length

	points.append(end_point)
	points.append(curve.sample(0, projectile_percent - multiplier))
	points.append(curve.sample(0, projectile_percent - 2 * multiplier))
	points.append(curve.sample(0, projectile_percent - 3 * multiplier))
	points.append(curve.sample(0, projectile_percent - 4 * multiplier))
	points.append(curve.sample(0, projectile_percent - 5 * multiplier))
	points.append(curve.sample(0, projectile_percent - 6 * multiplier))
	points.append(curve.sample(0, projectile_percent - 7 * multiplier))
	points.append(curve.sample(0, projectile_percent - 8 * multiplier))
	points.append(curve.sample(0, projectile_percent - 9 * multiplier))

	# It should take more time to go through a longer path
	projectile_percent += delta * multiplier * 100
	%Projectile.points = points

	
