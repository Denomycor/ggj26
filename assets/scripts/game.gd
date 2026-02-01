class_name Game extends Node

var level: Level = null

@onready var main_menu: MainMenu = $main_menu
const LEVEL_SCENE := preload("res://assets/scenes/level/level.tscn")

func _ready() -> void:
	main_menu.play.connect(load_level)


func load_level() -> void:
	level = LEVEL_SCENE.instantiate()
	level.get_node("game_over").over.connect(show_main_menu)
	add_child(level)
	main_menu.visible = false


func show_main_menu() -> void:
	get_tree().paused = false
	main_menu.visible = true
	remove_child(level)

