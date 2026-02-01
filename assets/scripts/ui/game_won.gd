class_name GameWon extends CanvasLayer


signal won


func _ready() -> void:
	%menu.pressed.connect(func():
		won.emit()
	)


func trigger_game_won() -> void:
	visible = true
	get_tree().paused = true
