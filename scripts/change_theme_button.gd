extends Button

@export var icons:Dictionary = {
	"dark_theme": preload("res://assets/sun.png"),
	"light_theme": preload("res://assets/moon.png")
}
func _on_button_down() -> void:
	print("mphke")
	if Global.ACTIVE_THEME == "dark_theme":
		Global.ACTIVE_THEME = "light_theme"
		self.icon = icons["light_theme"]
	else:
		Global.ACTIVE_THEME = "dark_theme"
		self.icon = icons["dark_theme"]
	SignalBus.change_theme.emit()

func set_icon():
	if Global.ACTIVE_THEME == "dark_theme":
		self.icon = icons["dark_theme"]
	else:
		self.icon = icons["light_theme"]
	

func _on_ready() -> void:
	set_icon()
