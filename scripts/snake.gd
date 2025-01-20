extends Node2D


## Game vars
var score : int
var game_started : bool = false
var game_active : bool = false

## Grid vars
var cells : int = 20
var cell_size : int = 50

var snake : Array[SnakePart] = []

## Movement vars
var start_pos = Vector2(9, 9)
var move_direction : Vector2
var move_direction_string : String
var can_move : bool
var time_between_moves : float = 10000.0
var time_since_last_move : float = 0
var speed : float = 1000.0
var speed_step : float = 25.0

@onready var head : SnakePart
@onready var bounds : Bounds = $Bounds as Bounds
@onready var spawner : Spawner = $Spawner as Spawner
@onready var hud: Hud = $Hud as Hud



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head = create_head()
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_snake_part.connect(_on_snake_collided)
	spawner.tail_added.connect(_on_tail_added)
	spawner.body_added.connect(_on_body_added)
	hud.play_again.connect(_on_play_again)
	hud.reset_all()
	new_game()
	


func new_game():
	#score = 0
	
	## set game params 
	hud.score_reset()
	move_direction = Vector2.RIGHT
	
	## Clear existing food
	var foods = get_children()
	for i in range(0, foods.size(), 1):
		if (foods[i].is_in_group("food")) || (foods[i].is_in_group("apple")):
			foods[i].call_deferred("queue_free")
		
	# Clear Snake
	for i in range(1, snake.size(), 1):
		snake[i].call_deferred("queue_free")
	snake.clear()
	
	## Attach head
	snake.append(head)
	
	## Spawn food
	spawner.spawn_food()
	spawner.spawn_apple()
	
	## Move Head to start_pos
	head.move_to(start_pos)
	
	## Reset speed
	speed = 1000.0
	
	## start game
	game_active = true

func create_head():
	head = spawner.spawn_head(start_pos)
	head.is_head = true
	head.dir = "right"
	return head
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_up"):
		move_direction = Vector2.UP
		move_direction_string = "up"
	
	if Input.is_action_pressed("ui_down"):
		move_direction = Vector2.DOWN
		move_direction_string = "down"
	
	if Input.is_action_pressed("ui_right"):
		move_direction = Vector2.RIGHT
		move_direction_string = "right"
	
	if Input.is_action_pressed("ui_left"):
		move_direction = Vector2.LEFT
		move_direction_string = "left"
	
	pass
	

func _physics_process(delta: float) -> void:
	if not game_active:
		return
	time_since_last_move += delta + speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		time_since_last_move = 0


func speed_up():
	speed +=  speed_step
	print("speed: ", speed)

func update_snake():
	
	var new_pos:Vector2 = head.position + move_direction * Global.TILE_SIZE
	new_pos = bounds.wrap_vector(new_pos)
	head.move_to(new_pos)
	head.update_head(move_direction_string)
	
	for i in range(1, snake.size(), 1):
		snake[i].move_to(snake[i-1].last_position)
		
	for i in range(snake.size()-1, 0, -1):
		var prev = null
		if i < snake.size() - 1:
			prev = snake[i+1]
		snake[i].update_body_part(prev, snake[i-1])
	pass
	
func _on_food_eaten(food:String):
	if not game_active:
		return
	if food == "apple":
		spawner.call_deferred("spawn_apple")
		if snake.size() == 1:
			spawner.call_deferred("spawn_tail", head.last_position)
		else:
			spawner.call_deferred("spawn_body", snake[snake.size()-2].last_position)
			snake[snake.size()-1].move_to(snake[snake.size()-1].last_position)
		hud.score_add(2)
	elif food == "food":
		spawner.call_deferred("spawn_food")
		hud.score_add(1)
	speed_up()
		
func _on_body_added(body:SnakePart):
	#print("Body Added")
	snake.insert(snake.size() -1, body)
	
func _on_tail_added(tail:SnakePart):
	#print("Tail added")
	snake.push_back(tail)


func _on_snake_collided():
	print("Game over!")
	game_active = false
	hud.game_over(score)
	pass
	
	
func _on_play_again():
	hud.reset_all()
	new_game()
