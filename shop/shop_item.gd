@tool

extends Control

@export var expand_mode: TextureRect.ExpandMode

# Set only the resource that needs to show up
@export var fruit_resource: FruitResouce:
	set(val):
		if val == null:
			return
		fruit_resource = val
		item_type = ItemType.Fruit
	get():
		return fruit_resource

@export var toy_resource: ToyResource:
	set(val):
		if val == null:
			return
		toy_resource = val
		item_type = ItemType.Toy
	get():
		return toy_resource

@export var consumable_resource: ConsumableResouce:
	set(val):
		if val == null:
			return
		consumable_resource = val
		item_type = ItemType.Consumable
	get():
		return consumable_resource

enum ItemType {
	Fruit,
	Toy,
	Consumable,
}
var item_type: ItemType


func _ready() -> void:
	_setup()

func reset():
	%DragableTextureRect.reset()

func _setup():
	%DragableTextureRect.expand_mode = expand_mode
	
	if fruit_resource != null:
		%DragableTextureRect.texture = fruit_resource.texture
		%DragableTextureRect.scale = Vector2(128., 128.) / fruit_resource.texture.get_size()
	if toy_resource != null:
		%DragableTextureRect.texture = toy_resource.texture
		%DragableTextureRect.scale = Vector2(128., 128.) / toy_resource.texture.get_size()
	if consumable_resource != null:
		%DragableTextureRect.texture = consumable_resource.texture
		%DragableTextureRect.scale = Vector2(128., 128.) / consumable_resource.texture.get_size()
