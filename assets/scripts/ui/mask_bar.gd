class_name MaskBar extends HBoxContainer

@export var slots: Array[MaskSlot]

var current_slot: MaskSlot

func change_slot(idx: int) -> void:
    if idx >= slots.size():
        return
    if current_slot!=null:
        current_slot.highlight(false)
    current_slot = slots[idx]
    current_slot.highlight(true)
