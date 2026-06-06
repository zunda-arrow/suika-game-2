@tool

extends Control

var hovered = false

@export var width: int

func _ready() -> void:
	$VBoxContainer.custom_minimum_size.x = width


func _on_v_box_container_focus_entered() -> void:
	hovered = true


func _on_v_box_container_focus_exited() -> void:
	hovered = false
