@tool
extends Control

# Sent when the mouse cursor releases on this object
signal item_dropped

var hovered = false

@export var width: int

@export var item_type: ItemType
enum ItemType {
	Fruit,
	Toy,
	Consumable,
}

func _ready() -> void:
	$VBoxContainer.custom_minimum_size.x = width


func _on_v_box_container_focus_entered() -> void:
	hovered = true


func _on_v_box_container_focus_exited() -> void:
	hovered = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("Click") and get_global_rect().has_point(get_global_mouse_position()):
		item_dropped.emit()
