class_name top10Entry extends GridContainer

@onready var top_10_name: top10Name = $top10Name as top10Name
@onready var top_10_score: top10Score = $top10Score as top10Score


var player_name : String
var player_score : int


func entry_set(name : String, score : int):
	player_name = name
	player_score = score
	
	if top_10_name and top_10_score:
		top_10_name.text = name
		top_10_score.text = str(score)
