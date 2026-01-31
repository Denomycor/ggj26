extends Node

const EventScript = preload("res://assets/scripts/events/event.gd")

@export var game_overlay: GameOverlay = null

const EVENTS: Dictionary = {
	"Event1": {
		"task_message": "Drink premium vodka from the bar",
		"event": null,
		"task": null,
	},
	"Event2": {
		"task_message": "Talk with the president",
		"event": null,
		"task": null,
	},
	"Event3": {
		"task_message": "Smoke a joint with the cool guy",
		"event": null,
		"task": null,
	},
	"Event4": {
		"task_message": "Dance with the prettiest girl ",
		"event": null,
		"task": null,
	},
	"Event5": {
		"task_message": "go for a pool dive",
		"event": null,
		"task": null,
	},
}

func _ready() -> void:
	var keys = EVENTS.keys()
	
	for k in keys:
		game_overlay.add_bucket_item(k, EVENTS[k].task_message)
	
	call_deferred("_after_ready")


func _after_ready() -> void:
	var keys = EVENTS.keys()
	
	for k in keys:
		var event_node: EventArea = get_node(k)

		if !event_node:
			push_error("Event node not found for key: %s" % k)
			get_tree().quit()  # Immediately stop the game to surface the critical error
