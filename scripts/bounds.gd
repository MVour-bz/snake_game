class_name Bounds extends Node2D

@onready var upper_left: Marker2D = %UpperLeft
@onready var down_right: Marker2D = %DownRight

var x_max:float
var y_max:float
var x_min:float
var y_min:float

var grid_tile_diff = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x_min = upper_left.position.x
	y_min = upper_left.position.y
	x_max = down_right.position.x
	y_max = down_right.position.y
	
	if Global.TILE_SIZE > Global.GRID_SIZE:
		grid_tile_diff = Global.TILE_SIZE - Global.GRID_SIZE
	else:
		grid_tile_diff = Global.GRID_SIZE - Global.TILE_SIZE
	


func wrap_vector(v:Vector2) -> Vector2:
	if v.x + grid_tile_diff > x_max:
		return Vector2(x_min + grid_tile_diff, v.y)
	if v.x - grid_tile_diff < x_min:
		return Vector2(x_max - grid_tile_diff, v.y)
	if v.y + grid_tile_diff > y_max:
		return Vector2(v.x, y_min + grid_tile_diff)
	if v.y - grid_tile_diff < y_min:
		return Vector2(v.x, y_max - grid_tile_diff)
	return v

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
