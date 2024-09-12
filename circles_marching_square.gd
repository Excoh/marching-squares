extends Node2D

@export var grid_color: Color = Color.DIM_GRAY
@export var is_grid_drawn: bool = true
@export var is_grid_debug_drawn: bool = true
## The number of cells for x and y axes.
## Setting this number too high will slow
## the program down.
@export var axis_count: Vector2i = Vector2i(15, 15)
## The resolution between cells for x and y axes
var resolution: Vector2 = Vector2.ZERO
var grid_size: Vector2i = Vector2i(600, 400)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_resolution()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		queue_redraw()

## Check to see if a point is in a circle
func is_in_circle(point_weight: float) -> int:
	return 0 if point_weight < 1.0 else 1

## Used to calculate the weight
## of each point to find the
## intermediate locations of the contour
func point_value(circles_array: Array, position: Vector2) -> float:
	var sum: float = 0
	for circle in circles_array:
		sum += circle.radius**2 / ((position.x-circle.position.x)**2 + (position.y-circle.position.y)**2)
	return sum

func _draw() -> void:
	if is_grid_drawn:
		draw_grid()
	for i in range(axis_count.x):
		for j in range(axis_count.y):
			var x: float = i * resolution.x
			var y: float = j * resolution.y
			var loc: Vector2 = Vector2(x, y)
			var mouse_pos: Vector2 = get_viewport().get_mouse_position()
			var circles: Array = [{"position": mouse_pos, "radius": 75}]
			circles.append({
				"position": Vector2(100,100),
				"radius": 25
			})
			circles.append({
				"position": Vector2(100,300),
				"radius": 50
			})
			circles.append({
				"position": Vector2(500,300),
				"radius": 60
			})
			if i <= axis_count.x-1 or j <= axis_count.y-1:
				##  p o----a----o q
				##    |         |
				##    d         b
				##    |         |
				##  r o----c----o s
				## ax, by, cx, and dy are equations to calculate
				## the intermediate location of the contours instead of just being in the middle
				## of the square, i.e. instead of being in the middles of p and q, q and s, etc.
				var p_pos = Vector2(x,y); var q_pos = Vector2(x+resolution.x, y)
				var r_pos = Vector2(x, y+resolution.y); var s_pos = Vector2(x+resolution.x, y+resolution.y)
				
				var p_weight: float = point_value(circles, p_pos)
				var q_weight: float = point_value(circles, q_pos)
				var r_weight: float = point_value(circles, r_pos)
				var s_weight: float = point_value(circles, s_pos)
				
				var ax = p_pos.x + ((q_pos.x - p_pos.x) * ((1-p_weight)/(q_weight-p_weight)))
				var by = q_pos.y + ((s_pos.y-q_pos.y) * ((1-q_weight)/(s_weight-q_weight)))
				var cx = r_pos.x +((s_pos.x-r_pos.x) * ((1-r_weight)/(s_weight-r_weight)))
				var dy = p_pos.y + ((r_pos.y-p_pos.y) * ((1-p_weight)/(r_weight-p_weight)))
				var a: Vector2 = Vector2(ax, y)
				var b: Vector2 = Vector2(x + resolution.x, by)
				var c: Vector2 = Vector2(cx, y + resolution.y)
				var d: Vector2 = Vector2(x, dy)
				var state: int = (
					8 * is_in_circle(p_weight) +
					4 * is_in_circle(q_weight) +
					2 * is_in_circle(s_weight) +
					1 * is_in_circle(r_weight)
					#a*8 + b*4 + c*2 + d*1
				)
				draw_contours(state, a,b,c,d)
			if is_grid_debug_drawn:
				var sum: float = 0
				for circle in circles:
					sum += circle.radius**2 / ((loc.x-circle.position.x)**2 + (loc.y-circle.position.y)**2)
				draw_circle(loc, 2.5, Color.WHEAT)
				draw_string(ThemeDB.fallback_font, loc + Vector2(6, 16), "{val}".format({"val":"%0.2f" % sum}),HORIZONTAL_ALIGNMENT_CENTER, -1, 12, Color.DIM_GRAY)
				draw_circles(circles)

func draw_circles(circles_array: Array) -> void:
	for circle in circles_array:
		draw_circle(circle.position, circle.radius, Color.RED, false)

func draw_grid() -> void:
	for i in range(axis_count.x):
		draw_line(Vector2(i*resolution.x, 0), Vector2(i*resolution.x, grid_size.y), grid_color)
	for i in range(axis_count.y):
		draw_line(Vector2(0, i*resolution.y), Vector2(grid_size.x, i*resolution.y), grid_color)

func update_resolution() -> void:
	resolution.x = (grid_size.x / axis_count.x)
	resolution.y = (grid_size.y / axis_count.y)

func draw_contours(idx: int, a: Vector2, b: Vector2, c: Vector2, d: Vector2) -> void:
	var line_col: Color = Color.LAWN_GREEN
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
