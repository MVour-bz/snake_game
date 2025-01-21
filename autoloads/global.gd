extends Node


const GRID_SIZE : int = 16
const TILE_SIZE : int = 32
const GAME_DATA_FILE_PATH : String = "res://data/game_data.json"

const PALLETES : Dictionary = {
	"dark_theme": {
		"primary": "#FF16FF",
		"secondary": "#16FFB596",
		"surface": "#1b03a396",
		"highlight": "#16FFB5",
		"background": "#1A1A1A",
		"glow": "#1600FF",
		"snake": "#FFFF00"
	},
	"light_theme": {
		"primary": "#FF16FF",
		"secondary": "#FF5E1696",
		"surface": "#1b03a396",
		"highlight": "#16FF5E",
		"background": "#FFFFFF",
		"glow": "#1600FF",
		"snake": "#00FF00"
	}
}

var ACTIVE_THEME = "light_theme"
