class_name Level extends Node


var suspicion := 0.0


func _ready() -> void:
	populate_level_context()


func populate_level_context() -> void:
	LevelContext.level = self
	LevelContext.player = $world/player
