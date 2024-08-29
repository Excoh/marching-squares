@tool
extends Node2D

@export var radius: float = 1.0:
	set(value):
		radius = value
		queue_redraw()

@export var cell_color_off: Color = Color.DIM_GRAY:
	set(value):
		cell_color_off = value
		queue_redraw()

@export var cell_color_on: Color = Color.ANTIQUE_WHITE:
	set(value):
		cell_color_on = value
		queue_redraw()

@export var line_color: Color = Color.CYAN:
	set(value):
		line_color = value
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
var field = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_cols_rows()
	queue_redraw()

func _draw() -> void:
	draw_grid()

func update_cols_rows() -> void:
	cols = 1 + int(grid_size.x / resolution)
	rows = 1 + int(grid_size.y / resolution)
	field.clear()
	for i in range(cols):
		field.append([])
		for j in range(rows):
			field[i].append(randi_range(0,1))

func draw_grid() -> void:
	for i in range(cols):
		for j in range(rows):
			draw_circle(Vector2(i*resolution, j*resolution), radius, cell_color_off if field[i][j] else cell_color_on)
	for i in range(cols-1):
		for j in range(rows-1):
			var x: float = i * resolution
			var y: float = j * resolution
			var a: Vector2 = Vector2(x + resolution*0.5, y)
			var b: Vector2 = Vector2(x + resolution, y + resolution*0.5)
			var c: Vector2 = Vector2(x + resolution*0.5, y + resolution)
			var d: Vector2 = Vector2(x, y  + resolution*0.5)
			var state: int = get_state(
				field[i][j],
				field[i+1][j],
				field[i+1][j+1],
				field[i][j+1]
			)
			draw_contours(state, a, b, c, d)

## Composition of the 4 bits at the corners of each cell to build
## a binary index. We go around in a clockwise direction appending the bit
## from most significant bit to least significant bit
## (a) o---o (b)
##     |   |
## (c) o---o (d)
func get_state(a: int, b: int, c: int, d: int) -> int:
	# 8 = 1000
	# 4 = 0100
	# 2 = 0010
	# 1 = 0001
	return a*8 + b*4 + c*2 + d*1

func draw_contours(idx: int, a: Vector2, b: Vector2, c: Vector2, d: Vector2) -> void:
	var line_col: Color = line_color
	match idx:
		0:
			# Do nothing, display no contours
			pass
		1:
			draw_line(d, c, line_col)
			pass
		2:
			draw_line(c, b, line_col)
			pass
		3:
			draw_line(d, b, line_col)
			pass
		4:
			draw_line(a, b, line_col)
			pass
		5:
			draw_line(a,d, line_col)
			draw_line(b, c, line_col)
			pass
		6:
			draw_line(a, c, line_col)
			pass
		7:
			draw_line(a, d, line_col)
			pass
		8:
			draw_line(a, d, line_col)
			pass
		9:
			draw_line(a, c, line_col)
			pass
		10:
			draw_line(a, b, line_col)
			draw_line(c, d, line_col)
			pass
		11:
			draw_line(a, b, line_col)
			pass
		12:
			draw_line(b, d, line_col)
			pass
		13:
			draw_line(b, c, line_col)
			pass
		14:
			draw_line(c, d, line_col)
			pass
		15:
			# Do nothing, display no contours
			pass
