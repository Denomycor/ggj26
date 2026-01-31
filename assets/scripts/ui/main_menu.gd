class_name MainMenu extends CanvasLayer


signal play


func _ready() -> void:
	%play.pressed.connect(play.emit)

