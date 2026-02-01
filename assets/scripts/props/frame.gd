extends Node


func _ready() -> void:
	var props = get_node("Props")
	var children = props.get_children()
	
	if children.size() > 0:
		var random_index = randi() % children.size()
		children[random_index].visible = true
