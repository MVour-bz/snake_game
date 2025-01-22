class_name Top10Panel extends Panel

@onready var score_container: GridContainer = $ScoreContainer


var top10_entry_scene:PackedScene = preload("res://scenes/top10Entry.tscn")


func set_top_10(items:Array):
	items = sort_top_10(items)
	var i = 0
	while i < items.size():
		var entry = top10_entry_scene.instantiate()
		
		score_container.add_child(entry)
		score_container.sort_children.emit()
		
		entry.entry_set(items[i].name, items[i].score)
		i += 1

func empty_top_10():
	var scre_cont_children = score_container.get_children()

	for i in range(0, scre_cont_children.size(), 1):
		
		scre_cont_children[i].call_deferred("queue_free")
	
func sort_top_10(items:Array):
	items.sort_custom(_copmare_scores)
	return items
	

func _copmare_scores(a, b):
	return  a["score"] > b["score"]
