class_name MaskSlot extends VBoxContainer

const HIGHLIGHT_COLOR := Color(0,0,0,1)
const NORMAL_COLOR := Color(1,1,1,1)

@export var border: TextureRect
@export var highlighted_border: TextureRect
@export var label: Label

func highlight(state: bool) -> void:
	border.visible = !state
	highlighted_border.visible = state
	if state:
		label.label_settings.font_color = HIGHLIGHT_COLOR
	else:
		label.label_settings.font_color = NORMAL_COLOR
