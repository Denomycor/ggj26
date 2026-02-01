class_name Game extends Node

var level: Level = null

@onready var main_menu: MainMenu = $main_menu
@export var intro_time: float = 5.0
const LEVEL_SCENE := preload("res://assets/scenes/level/level.tscn")
const INTRO_SCENE := preload("res://assets/scenes/ui/introduction.tscn")
const OUTRO_SCENE := preload("res://assets/scenes/ui/outro.tscn")

func _ready() -> void:
	main_menu.play.connect(load_intro)

func load_intro() -> void:
	var intro = INTRO_SCENE.instantiate()
	add_child(intro)
	main_menu.visible = false
	get_tree().paused = true
	await get_tree().create_timer(intro_time).timeout
	remove_child(intro)
	get_tree().paused = false
	load_level()

func load_level() -> void:
	level = LEVEL_SCENE.instantiate()
	level.get_node("game_over").over.connect(show_main_menu)
	level.get_node("game_won").won.connect(show_main_menu)
	add_child(level)
	main_menu.visible = false


func show_main_menu() -> void:
	print("Showing main menu")
	get_tree().paused = false
	main_menu.visible = true
	remove_child(level)

