class_name GameOverPanel extends Panel

func _on_ready() -> void:
	SignalBus.change_theme.connect(_on_theme_change)
	update_color()
	
func _on_theme_change():
	update_color()


func update_color():
	var style_box = get_theme_stylebox("panel")
	style_box.bg_color = Global.PALLETES[Global.ACTIVE_THEME].surface
	
