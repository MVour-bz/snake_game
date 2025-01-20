class_name Top10Panel extends Panel

@onready var item_list: ItemList = $ItemList as ItemList


func set_top_10(items:Array):
	for i in items.size():
		item_list.addItem(items[i].name, ":   " , items[i].score)
		#item_list.add_item()
