class_name StoreScorePanel extends Panel

signal store_score
@onready var score_lbl: Label = $VBoxContainer/Score
@onready var line_edit: LineEdit = $VBoxContainer/LineEdit
@onready var save_button: SaveButton = $VBoxContainer/SaveButton

func set_score_label(score):
	score_lbl.text = str(score)

func _on_save_button_pressed() -> void:
	store_score.emit(line_edit.text, int(score_lbl.text))
	save_button.disabled = true


func _on_ready() -> void:
	SignalBus.change_theme.connect(_on_theme_change)
	update_color()
	
func _on_theme_change():
	update_color()


func update_color():
	var panel_style_box = get_theme_stylebox("panel")
	panel_style_box.bg_color = Global.PALLETES[Global.ACTIVE_THEME].secondary
	
	var btn_style_box = save_button.get_theme_stylebox("normal")
	btn_style_box.bg_color = Global.PALLETES[Global.ACTIVE_THEME].primary
	
	
	
