class_name Notifier extends Sprite2D


@export var question_mark: Texture2D
@export var exclamation_mark: Texture2D


func play(tex: Texture2D) -> void:
	texture = tex
	rotation = deg_to_rad(90)
	scale = Vector2(0.5, 0.5)
	visible = true
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "rotation", 0, 0.6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel(false)
	tween.tween_interval(2)
	tween.tween_callback(func():
		visible = false
	)

