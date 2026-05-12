extends TextureRect
class_name DragableTextureRect


signal drag_started(start_pos: int)
signal drag_ended(end_pos: int)

var is_dragging = false
var start_pos = Vector2(0, 0)
var start_mouse_offset = Vector2(0, 0)

func _ready() -> void:
	start_pos = global_position

func reset():
	global_position = start_pos

func _on_gui_input(event: InputEvent) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - start_mouse_offset

	if event.is_action_pressed("Click") and not is_dragging:
		start_pos = position
		is_dragging = true
		start_mouse_offset = get_global_mouse_position() - global_position
		drag_started.emit(position)
		
	if event.is_action_released("Click"):
		is_dragging = false
		drag_ended.emit(position)
