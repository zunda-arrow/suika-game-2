@tool
extends Node2D

@export var start: Vector2
@export var end: Vector2
@export var particle_gravity = -9.8
@export var speed = 500

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		pass

	$Path2D.curve.set_point_position(1, end)
	
	var x = end.x - start.x
	var y = end.y - start.x
	var g = particle_gravity
	var a = -g * (x ** 2) / speed
	var a_arrival = -g * (end.x ** 2) / speed
	var tan_launch = -x + sqrt(x ** 2 + 4 * a * (y + a)) / (2 * a)
	var launch = atan(tan_launch)
	var tan_arrival = -end.x + sqrt(end.x ** 2 + 4 * a_arrival * (y + a_arrival)) / (2 * a_arrival)
	var arrival = atan(tan_arrival)
	
	var sign = 1
	if (end.x < start.x):
		sign = -1
	
	$Path2D.curve.set_point_out(0, Vector2i(cos(launch) * sign * speed,sin(launch) * sign * speed))
	$Path2D.curve.set_point_in(1, Vector2i(cos(arrival) * sign * speed,sin(arrival) * sign * speed))

	$Sprite2D.position = end
