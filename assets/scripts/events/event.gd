class_name EventArea extends Node2D

@onready var area2d: Area2D = $Area2D

var time_in_area: float = 0.0
var has_triggered: bool = false
const REQUIRED_TIME: float = 1.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if area2d.has_overlapping_bodies():
		if not has_triggered:
			time_in_area += delta
			if time_in_area >= REQUIRED_TIME:
				print("emitting check_bucket_item(%s)" % name)
				LevelContext.game_overlay.check_bucket_item.emit(name)
				has_triggered = true
	else:
		time_in_area = 0.0
