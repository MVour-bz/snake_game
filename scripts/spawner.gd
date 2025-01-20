class_name Spawner extends Node2D

signal tail_added
signal body_added

@export var bounds:Bounds

var food_scene:PackedScene = preload("res://scenes/food.tscn")
var apple_scene:PackedScene = preload("res://scenes/apple.tscn")
#var body_scene:PackedScene = preload("res://scenes/body.tscn")
#var tail_scene:PackedScene = preload("res://scenes/tail.tscn")
var snake_part:PackedScene = preload("res://scenes/snake_part.tscn")


func spawn_food():
	var spawn_point : Vector2 = Vector2.ZERO
	
	spawn_point.x = randf_range(bounds.x_min + Global.GRID_SIZE, bounds.x_max - Global.GRID_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.GRID_SIZE, bounds.y_max - Global.GRID_SIZE)
	
	spawn_point.x = floorf(spawn_point.x / Global. TILE_SIZE ) * Global.TILE_SIZE
	spawn_point.y = floorf(spawn_point.y / Global. TILE_SIZE ) * Global.TILE_SIZE
	
	
	var food = food_scene.instantiate()
	food.position = spawn_point
	food.name = "Food"
	get_parent().call_deferred("add_child", food)
	
	
func spawn_apple():
	var spawn_point : Vector2 = Vector2.ZERO
	
	spawn_point.x = randf_range(bounds.x_min + Global.GRID_SIZE, bounds.x_max - Global.GRID_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.GRID_SIZE, bounds.y_max - Global.GRID_SIZE)
	
	spawn_point.x = floorf(spawn_point.x / Global. TILE_SIZE ) * Global.TILE_SIZE
	spawn_point.y = floorf(spawn_point.y / Global. TILE_SIZE ) * Global.TILE_SIZE
	
	
	var apple:Apple = apple_scene.instantiate() as Apple
	apple.position = spawn_point
	apple.name = "Apple"
	
	get_parent().call_deferred("add_child", apple)


func spawn_snake_part(part, pos):
	if part == "tail":
		spawn_tail(pos)
	elif part == "head":
		spawn_head(pos)
	elif part == "body":
		spawn_body(pos)
	
	
func spawn_tail(pos:Vector2):
	var tail:SnakePart = snake_part.instantiate()
	tail.position = pos
	tail.is_tail = true
	tail.use_texture("snake_tail_down", 0)
	get_parent().add_child(tail)
	tail_added.emit(tail)
	
	
func spawn_body(pos:Vector2):
	var body:SnakePart = snake_part.instantiate()
	body.position = pos
	body.is_body = true
	body.use_texture("snake_up_down", 0)
	get_parent().add_child(body)
	body_added.emit(body)
	
	
func spawn_head(pos:Vector2):
	
	var head:SnakePart = snake_part.instantiate()
	head.use_texture("snake_head", 0)
	head.position = pos
	head.is_head = true
	get_parent().add_child(head)
	return head
	#tail_added.emit(head)
	
