class_name Hud extends CanvasLayer

@onready var animation_player: AnimationPlayer = $GameOverPanel/Label/AnimationPlayer
@onready var game_over_panel: Panel = $GameOverPanel
@onready var play_again_button: PlayAgainButton = $Button

signal play_again


var score : int = 0

func score_add(to_add : int):
	score += to_add
	score_update()
	
func score_reset():
	score = 0
	score_update()

func score_update():
	self.get_node("ScoreLabel").text = "SCORE: " + str(score)

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
	
func game_over():
	play_again_button.show()
	game_over_panel.show()
	animation_player.play("TEXT_GROW")
	
