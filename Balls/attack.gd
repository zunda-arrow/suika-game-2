@tool
extends Node2D

@export var aim_at: Node2D

@export var particle_gravity = -9.8
@export var speed = 500
@export var one_shot = true

var one_shot_and_hit_the_target = false

signal hit_the_target

var projectile_percent = 0

func _process(delta: float) -> void:
	if one_shot_and_hit_the_target:
		queue_free()
		return

	if not Engine.is_editor_hint():
		pass

	if projectile_percent > 1:
		if one_shot:
			one_shot_and_hit_the_target = true
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
	
	$Path2D.curve.set_point_out(0, Vector2i(cos(launch) * speed,sin(launch) * speed))
	$Path2D.curve.set_point_in(1, Vector2i(cos(arrival) * speed,sin(arrival) * speed))

	$Sprite2D.position = end
	
	var points = PackedVector2Array()
	var curve: Curve2D = $Path2D.get_curve()
	var end_point = curve.sample(0, projectile_percent)

	points.append(end_point)
	points.append(curve.sample(0, projectile_percent - .01))
	points.append(curve.sample(0, projectile_percent - .02))
	points.append(curve.sample(0, projectile_percent - .03))
	points.append(curve.sample(0, projectile_percent - .04))
	points.append(curve.sample(0, projectile_percent - .05))
	points.append(curve.sample(0, projectile_percent - .06))
	points.append(curve.sample(0, projectile_percent - .07))
	points.append(curve.sample(0, projectile_percent - .08))
	points.append(curve.sample(0, projectile_percent - .09))

	projectile_percent += delta
	%Projectile.points = points

	
