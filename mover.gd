extends Sprite2D

@export var label: Label
@export var resolution: int = 10

var target_pos: Vector2
var is_moving: bool = false

func _ready() -> void:
	target_pos = position

func _process(delta: float) -> void:
	if not is_moving:
		if Input.is_action_just_pressed(&"player_right"):
			target_pos = position + Vector2.RIGHT * resolution
			is_moving = true
		if Input.is_action_just_pressed(&"player_left"):
			target_pos = position + Vector2.LEFT * resolution
			is_moving = true
		if Input.is_action_just_pressed(&"player_down"):
			target_pos = position + Vector2.DOWN * resolution
			is_moving = true
		if Input.is_action_just_pressed(&"player_up"):
			target_pos = position + Vector2.UP * resolution
			is_moving = true

	if not target_pos.is_equal_approx(position):
		position = position.lerp(target_pos, delta*60)
	else:
		position = target_pos
		is_moving = false

	if label:
		label.text = str(position)
