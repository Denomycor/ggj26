class_name GameOverlay extends CanvasLayer

# Signals for external control
signal toggle_bucket_list
signal check_bucket_item(item_id: String)

const ITEM_SCENE: PackedScene = preload("res://assets/scenes/ui/bucket_list_items.tscn")

# Internal state
var _bucket_list_visible: bool = true
var _bucket_items: Dictionary = {}  # item_id -> {message: String, checked: bool}
@export var mask_bar: MaskBar

# UI References (set these in the editor or via code)
@onready var list_container: Control = $bucket_list
@onready var list: VBoxContainer = $bucket_list/VBoxContainer


func _ready() -> void:
	# Connect signals to internal handlers
	toggle_bucket_list.connect(_on_toggle_bucket_list)
	check_bucket_item.connect(_on_check_bucket_item)
	mask_bar.change_slot(0)


# Direct function to add items to the bucket list
func add_bucket_item(item_id: String, message: String) -> void:
	if _bucket_items.has(item_id):
		return
	
	_bucket_items[item_id] = {
		"message": message,
		"checked": false
	}

	var new_item = ITEM_SCENE.instantiate()
	new_item.name = item_id
	new_item.task_name = message

	list.add_child(new_item)


# Signal handler: Toggle bucket list visibility
func _on_toggle_bucket_list() -> void:
	_bucket_list_visible = not _bucket_list_visible
	list_container.visible = _bucket_list_visible


# Signal handler: Check an item in the bucket list
func _on_check_bucket_item(item_id: String) -> void:
	list.get_node(item_id).check()
	_bucket_items[item_id]["checked"] = true
	if is_bucket_list_done():
		LevelContext.game_won.trigger_game_won()

func is_bucket_list_done() -> bool:
	for item in _bucket_items.values():
		if not item["checked"]:
			return false
	return true
