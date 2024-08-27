@tool
extends Node2D

@export var radius: float = 1.0:
	set(value):
		radius = value
		queue_redraw()

@export var grid_color: Color = Color.GHOST_WHITE:
	set(value):
		grid_color = value
		queue_redraw()

@export_range(5, 50) var resolution: int = 10:
	set(value):
		resolution = value
		update_cols_rows()
		queue_redraw()

@export var grid_size: Vector2i = Vector2i(600, 400):
	set(value):
		grid_size = value
		update_cols_rows()
		queue_redraw()

var cols: int
var rows: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cols = int(grid_size.x / resolution)
	rows = int(grid_size.y / resolution)
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	draw_grid()

func update_cols_rows() -> void:
	cols = int(grid_size.x / resolution)
	rows = int(grid_size.y / resolution)

func draw_grid() -> void:
	for i in range(cols):
		for j in range(rows):
			draw_circle(Vector2(i*resolution, j*resolution), radius, grid_color)
