extends Node2D
class_name FlavorText

var opacity = 1
var initial_up_velocity = -500
var x_speed = randi_range(-200, 200)

func _ready() -> void:
	$Label.label_settings = $Label.label_settings.duplicate()

func set_damage_number(value: int):
	$Label.text = str(value)

func set_flavor_text(value: String):
	$Label.text = value

func _process(delta: float) -> void:
	initial_up_velocity += 2000 * delta
	global_position.y += initial_up_velocity * delta
	global_position.x += x_speed * delta
	scale *= 1 - (delta * .5)

	$Label.label_settings.font_color.a = opacity
	$Label.label_settings.outline_color.a = opacity

	if opacity <= 0:
		queue_free()
