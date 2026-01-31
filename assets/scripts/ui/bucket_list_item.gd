class_name BucketListItem extends Control

@export var task_name: String = ""

@onready var label: Label = $Label
@onready var checkbox_checked: Sprite2D = $CheckboxChecked
@onready var checkbox_unchecked: Sprite2D = $CheckboxUnchecked


func _ready() -> void:
	label.text = task_name

func check() -> void:
	checkbox_checked.visible = true
	checkbox_unchecked.visible = false
