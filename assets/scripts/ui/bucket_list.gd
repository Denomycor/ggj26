class_name BucketList extends VBoxContainer

@export var slots: Array[BucketListItem]

func check_task(task_name: String) -> void:
    var idx := find_task(task_name)
    if idx != -1:
        slots[idx].check()

func find_task(task_name: String) -> int:
    for i in slots.size():
        if slots[i].task_name == task_name:
            return i
    return -1