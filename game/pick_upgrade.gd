extends Control

signal upgrade_picked(number: int)

var curr_upgrade_hovered = -1

var dragable_sprite = preload("res://include/dragable_sprite/DragableTextureRect.tscn")
var upgrade_texture_rects: Array[DragableTextureRect] = []

class Upgrade:
	var ball: FruitResouce

func _ready() -> void:
	show_upgrade_list([
		new_ball_upgrade(R.Fruits["default"]),
		new_ball_upgrade(R.Fruits["bomb"]),
		new_ball_upgrade(R.Fruits["bomb"]),
	])

func new_ball_upgrade(ball) -> Upgrade:
	var u = Upgrade.new()
	u.ball = ball
	return u


func show_upgrade_list(upgrades: Array[Upgrade]):
	for i in range(len(upgrades)):
		var u: DragableTextureRect = dragable_sprite.instantiate()

		if upgrades[i].ball != null:
			pass

		u.drag_ended.connect(drag_ended(i))
		$HBoxContainer.add_child(u)
		upgrade_texture_rects.push_back(u)

func drag_ended(i):
	return func(_end_pos):
		if curr_upgrade_hovered < 0:
			upgrade_texture_rects[i].reset()
			return
		
		# Otherwise we pick the upgrade
		upgrade_picked.emit(i)
		upgrade_texture_rects[i].queue_free()
		upgrade_texture_rects[i] = null

func _on_upgrades_list_upgrade_hovered(hovered: int) -> void:
	curr_upgrade_hovered = hovered
