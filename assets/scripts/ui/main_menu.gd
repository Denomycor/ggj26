class_name MainMenu extends CanvasLayer


signal play


func _ready() -> void:
	%play.pressed.connect(play.emit)
	%credits.pressed.connect(func(): $TabContainer.current_tab = 1)
	%back.pressed.connect(func(): $TabContainer.current_tab = 0)

