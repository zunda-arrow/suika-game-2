extends Node2D

# Set only the resource that needs to show up
@export var fruit_resource: FruitResouce:
	set(val):
		fruit_resource = val
		item_type = ItemType.Fruit
	get():
		return fruit_resource

enum ItemType {
	Fruit,
}
var item_type: ItemType


func _ready() -> void:
	_setup()

func _setup():
	if item_type == ItemType.Fruit and fruit_resource != null:
		%DragableTextureRect.texture = fruit_resource.texture
		%DragableTextureRect.scale = Vector2(128., 128.) / fruit_resource.texture.get_size()
