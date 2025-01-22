class_name Hud extends Node2D

@onready var game_over_panel: Panel = $Hud/GameOverPanel
@onready var score_label: Label = $Hud/ScorePanel/ScoreLabel
@onready var animation_player: AnimationPlayer = $Hud/GameOverPanel/Label/AnimationPlayer
@onready var play_again_button: PlayAgainButton = $Hud/Button as PlayAgainButton
@onready var high_score_label: Label = $Hud/ScorePanel/HighScoreLabel
@onready var top_10_panel: Top10Panel = $Hud/Top10Panel as Top10Panel
@onready var store_score_panel: StoreScorePanel = $Hud/StoreScorePanel
@onready var save_button: SaveButton = $Hud/StoreScorePanel/VBoxContainer/SaveButton

@onready var game_data_file
@onready var statistics_dict

signal play_again

var base_stats_dict = {
	"top_10": [], "high_score": { "name" : "", "score": 0}
}


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
	store_score_panel.hide()
	top_10_panel.hide()
	score_reset()
	
func game_over():
	print("score: ", score)
	play_again_button.show()
	game_over_panel.show()
	animation_player.play("TEXT_GROW")
	top_10_panel.show()
	
	if is_top_10(score):
		store_score_panel.show()
		store_score_panel.set_score_label(score)
		save_button.disabled = false
	
	

func open_game_file():
	var json = JSON.new()
	game_data_file = FileAccess.open(Global.GAME_DATA_FILE_PATH, FileAccess.READ)
	var game_data_str = game_data_file.get_file_as_string(Global.GAME_DATA_FILE_PATH)
	statistics_dict = json.parse_string(game_data_str)
	#sort dict:
	if statistics_dict == null:
		statistics_dict = base_stats_dict
	statistics_dict["top_10"].sort_custom(func(a,b):
		return a["score"]-b["score"])
	game_data_file.close()
	
func get_top_10():
	return statistics_dict["top_10"]
	
func get_high_score():
	return statistics_dict["high_score"]
	
func is_top_10(score):
	if statistics_dict["top_10"].size() < 10:
		return true
	for i in range(0, statistics_dict["top_10"].size(), 1):
		#print("compare: ", score, " , ", statistics_dict["top_10"][i])
		if score > statistics_dict["top_10"][i].score:
			return true
	return false
		
func is_high_score(score):
	if score > statistics_dict["high_score"].score:
		return true
	else:
		return false
		
func update_game_statistics(name, score) -> bool:
	if not is_top_10(score) || score <=0:
		return false
	
	var inserted = false
	for i in range(0, statistics_dict["top_10"].size(), 1):
		if score > statistics_dict["top_10"][i].score:
			inserted = true
			statistics_dict["top_10"].insert(i, {"name": name, "score": score})
			break
	
	if not inserted:
		statistics_dict["top_10"].append({"name": name, "score": score})
	
	if statistics_dict["top_10"].size() > 10:
		statistics_dict["top_10"] = statistics_dict["top_10"].slice(0,10)
	
	if score > statistics_dict["high_score"].score:
		statistics_dict["high_score"] = {"name": name, "score": score}
		update_high_score_label(name, score)
	
	statistics_dict["top_10"].sort_custom(func(a,b):
		return a["score"]>b["score"])
	store_updated_dict()
	print("updated")
	return true

func update_high_score_label(name, score):
	high_score_label.text = "HIGH\nSCORE: " + str(score)
	
func store_updated_dict():
	var json = JSON.new()
	game_data_file = FileAccess.open(Global.GAME_DATA_FILE_PATH, FileAccess.WRITE)
	#var statistics_str = json.stringify(statistics_dict)
	
	game_data_file.store_string(JSON.stringify(statistics_dict)) ## ifnot try to store the statistics str
	
	game_data_file.close()
	#game_data_file.store_string()


func _on_store_score_panel_store_score(name, score) -> void:
	print("clicked, score: ", score)
	if update_game_statistics(name, score):
		top_10_panel.empty_top_10()
		top_10_panel.set_top_10(statistics_dict["top_10"])
