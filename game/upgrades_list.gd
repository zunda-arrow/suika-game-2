extends VBoxContainer

signal upgrade_hovered(hovered: int)


var last_hovered = -1

func _process(_delta: float) -> void:
	var h = get_hovered()
	
	if h != last_hovered:
		last_hovered = h
		upgrade_hovered.emit(h)

func get_hovered() -> int:
	var mouse_pos = get_global_mouse_position()

	if $UpgradeOne.get_global_rect().has_point(mouse_pos):
		return 0
	if $UpgradeTwo.get_global_rect().has_point(mouse_pos):
		return 1
	if $UpgradeThree.get_global_rect().has_point(mouse_pos):
		return 2
	if $UpgradeFour.get_global_rect().has_point(mouse_pos):
		return 3
	if $UpgradeFive.get_global_rect().has_point(mouse_pos):
		return 4

	return -1
