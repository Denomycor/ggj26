extends CanvasLayer

var state := false

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        state = !state
        get_tree().paused = state
        visible = state

