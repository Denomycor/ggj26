class_name Level extends Node


var suspicion := 0.0


func _ready() -> void:
	init_level_context()


func init_level_context() -> void:
	LevelContext.level = self
	LevelContext.player = $world/player
	LevelContext.cop_coordinator = $world/cop_coordinator

