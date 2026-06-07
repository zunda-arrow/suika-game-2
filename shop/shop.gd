extends Control

signal upgrade_picked(shop_item: Upgrade)

var dragable_sprite = preload("res://include/dragable_sprite/DragableTextureRect.tscn")
var upgrade_texture_rects: Array[DragableTextureRect] = []
var shop_items = []

class Upgrade:
	var ball: FruitResouce

func _ready() -> void:
	for i in [
		%Toy1,
		%Toy2,
		%Toy3,
		%Fruit1,
		%Fruit2,
		%Candy1,
		%Candy2,
	]:
		i.connect("gui_input", func(input: InputEvent):
			if input.is_action("Click") and input.is_pressed():
				upgrade_picked.emit(i)
			if input.is_action("Click") and input.is_released():
				i.reset()
			)

func new_ball_upgrade(ball) -> Upgrade:
	var u = Upgrade.new()
	u.ball = ball
	return u


func show_upgrade_list(upgrades: Array[Upgrade]):
	return
