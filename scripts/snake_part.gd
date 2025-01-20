class_name SnakePart extends Area2D

signal food_eaten
signal collided_with_snake_part

@export var textures:Dictionary = {
	"snake_tail_down": preload("res://assets/snake_tail.png"),
	"snake_up_down": preload("res://assets/snake_body.png"),
	"snake_right_down": preload("res://assets/snake_body_turn.png"),
	"snake_head": preload("res://assets/snake_head.png")
}

var last_position : Vector2
var dir:String
var is_head:bool = false
var is_turn:bool = false
var is_tail:bool = false
var is_body:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move_to(new_position:Vector2):
	last_position = self.position
	self.position = new_position


func update_head(next_dir:String):
	# 0. Turn Head
	if is_head:
		if dir != next_dir:
			if next_dir == "up":
				use_texture("snake_head", 180)
			if next_dir == "down":
				use_texture("snake_head", 0)
			if next_dir == "right":
				use_texture("snake_head", -90)
			if next_dir == "left":
				use_texture("snake_head", 90)
		dir = next_dir
		return


func update_body_part(pre, next):
	#print("dir: ", dir, ", pre_dir: " , pre.dir, ", next_dir: ", next.dir)
	
	if is_tail:
		if next.dir == "down":
			use_texture("snake_tail_down", 0)
		elif next.dir == "up":
			use_texture("snake_tail_down", 180)
		elif next.dir == "right":
			use_texture("snake_tail_down", -90)
		elif next.dir == "left":
			use_texture("snake_tail_down", 90)
		dir = next.dir
		pass
	
	if is_turn || is_body:
		if next.dir == "turn":
			dir = next.dir
			return
		# 3. Case: No turn && not already aligned:
		if pre.dir == next.dir :
			if next.dir == "up" || next.dir == "down":
				use_texture("snake_up_down", 0)
			elif next.dir == "right" || next.dir == "left":
				use_texture("snake_up_down", 90)
			dir = next.dir
			is_body = true
			is_turn = false
			return
		# 4. Case: Check turn
		if pre.dir != next.dir:
			if (pre.dir == "up" && next.dir == "right") || (pre.dir == "left" && next.dir == "down"):
				use_texture("snake_right_down", 0)
					
			if (pre.dir == "up" && next.dir == "left") || (pre.dir == "right" && next.dir == "down"):
				use_texture("snake_right_down", 90)
					
			if (pre.dir == "down" && next.dir == "right") || (pre.dir == "left" && next.dir == "up"):
				use_texture("snake_right_down", -90)
				
			if (pre.dir == "down" && next.dir == "left") || (pre.dir == "right" && next.dir == "up"):
				use_texture("snake_right_down", 180)
			
			is_turn = true
			is_body = false
			dir = next.dir
			return




func use_texture(target, rotate):
	var body = get_node("Sprite2D")
	if target in textures.keys():
		body.texture = textures[target]
		body.rotation_degrees = rotate


func _on_area_entered(area: Area2D) -> void:
	if not is_head:
		return
		
	
	#var apple = area as Apple
	
	if area.is_in_group("food"):
		food_eaten.emit("food")
		area.call_deferred("queue_free")
	elif area.is_in_group("apple"):
		food_eaten.emit("apple")
		area.call_deferred("queue_free")
	elif area.is_in_group("snake"):
		collided_with_snake_part.emit()
	
