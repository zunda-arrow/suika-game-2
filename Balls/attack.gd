@tool
extends Node2D

@export var start: Vector2
@export var end: Vector2

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		$GPUParticles2D.one_shot = true
		$GPUParticles2D.emitting = false

	var R = abs(end.x - start.x)
	var dy = abs(end.y - start.y)
		
	var theta = (1./2.) * atan(R / (dy + sqrt(R**2 + dy**2)))
	var v_zero = sqrt(98**2 / (2 * cos(theta * abs(dy * R * tan(theta)))))
	var v = Vector2(sin(theta) * v_zero, cos(theta) * v_zero).length()

	$GPUParticles2D.process_material.initial_velocity = Vector2(v, v)
	$GPUParticles2D.process_material.direction = Vector3(sin(theta), -cos(theta), 0)
