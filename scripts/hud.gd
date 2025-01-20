class_name Hud extends Node2D

@onready var game_over_panel: Panel = $Hud/GameOverPanel
@onready var score_label: Label = $Hud/ScorePanel/ScoreLabel
@onready var animation_player: AnimationPlayer = $Hud/GameOverPanel/Label/AnimationPlayer
@onready var play_again_button: PlayAgainButton = $Hud/Button as PlayAgainButton
@onready var high_score_label: Label = $Hud/ScorePanel/HighScoreLabel
@onready var top_10_panel: Top10Panel = $Hud/Top10Panel as Top10Panel

@onready var game_data_file
@onready var statistics_dict

signal play_again


var score : int = 0



func _on_ready() -> void:
	open_game_file()
	update_high_score_label("", statistics_dict["high_score"]["score"])
	top_10_panel.set_top_10(statistics_dict["top_10"])


func score_add(to_add : int):
	score += to_add
	score_update()
	
func score_reset():
	score = 0
	score_update()

func score_update():
	score_label.text = "SCORE: " + str(score)

func game_over_start_animation():
	animation_player.play()
	
func game_over_stop_animation():
	animation_player.stop()

func _on_button_pressed() -> void:
	play_again.emit()
	
func reset_all():
	animation_player.stop()
	play_again_button.hide()
	game_over_panel.hide()
	score_reset()
	
func game_over(score):
	play_again_button.show()
	game_over_panel.show()
	animation_player.play("TEXT_GROW")
	
	if is_top_10(score):
		if is_high_score(score):
			pass
		else:
			pass
		update_game_statistics("", score)
	

func open_game_file():
	var json = JSON.new()
	game_data_file = FileAccess.open(Global.GAME_DATA_FILE_PATH, FileAccess.READ_WRITE)
	var game_data_str = game_data_file.get_file_as_string(Global.GAME_DATA_FILE_PATH)
	statistics_dict = json.parse_string(game_data_str)
	#sort dict:
	statistics_dict["top_10"].sort_custom(func(a,b):
		return b["score"]-a["score"])
	
func get_top_10():
	return statistics_dict["top_10"]
	
func get_high_score():
	return statistics_dict["high_score"]
	
func is_top_10(score):
	for i in range(0, statistics_dict["top_10"].size(), 1):
		if score > statistics_dict["top_10"][i].score:
			return true
	return false
		
func is_high_score(score):
	if score > statistics_dict["high_score"].score:
		return true
	else:
		return false
		
func update_game_statistics(name, score):
	if not is_top_10(score) || score <=0:
		return
	
	var inserted = false
	for i in range(0, statistics_dict["top_10"].size(), 1):
		if score > statistics_dict["top_10"][i].score:
			inserted = true
			statistics_dict["top_10"].insert(i, {"name": name, "score": score})
	
	if not inserted:
		statistics_dict["top_10"].append({"name": name, "score": score})
	
	if statistics_dict["top_10"].size() > 10:
		statistics_dict["top_10"].remove(10)
	
	if score > statistics_dict["high_score"]:
		statistics_dict["high_score"] = {"name": name, "score": score}
		update_high_score_label(name, score)
	
	
	return false

func update_high_score_label(name, score):
	high_score_label.text = "HIGH\nSCORE: " + str(score)
	
	
