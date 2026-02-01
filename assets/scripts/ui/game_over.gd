class_name GameOver extends CanvasLayer


signal over


func _ready() -> void:
    %menu.pressed.connect(func():
        over.emit()
    )


func trigger_game_over() -> void:
    visible = true
    get_tree().paused = true

