@tool
extends Node2D

@export var start: Vector2
@export var end: Vector2

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		$GPUParticles2D.one_shot = true
		$GPUParticles2D.emitting = false

	var R = abs(end.x - start.x)
	var dy = start.y - end.y
	
	# 45 degree angle
	var theta = atan(R / (dy + sqrt(R**2 + dy**2))) * (1./2.)
	var v_zero = sqrt((98 * R**2) / (2 * (cos(theta)**2) * abs(dy - (R * tan(theta)))))

	$GPUParticles2D.position = start
	$GPUParticles2D.process_material.initial_velocity = Vector2(v_zero, v_zero)
	$GPUParticles2D.process_material.direction = Vector3(cos(theta), -sin(theta), 0)

	$Sprite2D.position = end
