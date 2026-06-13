@tool
extends Control

# Sent when the mouse cursor releases on this object
signal item_dropped

var hovered = false

@export var width: int

@export var default_resource: Resource

@export var item_type: ItemType
enum ItemType {
	Fruit,
	Toy,
	Consumable,
}

func _ready() -> void:
	$VBoxContainer.custom_minimum_size.x = width
	
	if default_resource != null:
		set_resource(default_resource)


func _on_v_box_container_focus_entered() -> void:
	hovered = true


func _on_v_box_container_focus_exited() -> void:
	hovered = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("Click") and get_global_rect().has_point(get_global_mouse_position()):
		item_dropped.emit()

func set_resource(resource):
	if item_type == ItemType.Fruit:
		%ShopItem.fruit_resource = resource
	if item_type == ItemType.Toy:
		%ShopItem.toy_resource = resource
	if item_type == ItemType.Consumable:
		%ShopItem.consumable_resource = resource

func get_resource():
	if item_type == ItemType.Fruit:
		return %ShopItem.fruit_resource
	if item_type == ItemType.Toy:
		return %ShopItem.toy_resource
	if item_type == ItemType.Consumable:
		return %ShopItem.consumable_resource
