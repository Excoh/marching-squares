extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom += Vector2.ONE * 0.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			var target_zoom = zoom - (Vector2.ONE * 0.1)
			if target_zoom.x + target_zoom.y >= 2:
				zoom = target_zoom
		elif event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			zoom = Vector2.ONE
