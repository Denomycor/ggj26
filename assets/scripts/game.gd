class_name Game extends Node

@onready var main_menu: MainMenu = $main_menu
const LEVEL_SCENE := preload("res://assets/scenes/level/level.tscn")

func _ready() -> void:
	main_menu.play.connect(load_level)


func load_level() -> void:
	var level: Level = LEVEL_SCENE.instantiate()
	add_child(level)
	main_menu.visible = false

