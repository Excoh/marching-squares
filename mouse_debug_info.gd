extends Node2D
@export var point_color: Color = Color.MAGENTA
@export var circle_color: Color = Color.RED
@export var point_size: float = 2.0
@export var radius: float = 75
@export var is_mouse_visible: bool = true
@export var is_debug_info_visible: bool = true

func _ready() -> void:
	if not is_mouse_visible:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	if is_debug_info_visible:
		$Label.visible = true
	else:
		$Label.visible = false

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	if is_debug_info_visible and event is InputEventMouseMotion:
		$Label.text = str(event.position)
		position = event.position
		

func _draw() -> void:
	if is_debug_info_visible:
		draw_circle(Vector2.ZERO, point_size, point_color)
		draw_circle(Vector2.ZERO, radius, circle_color, false)
