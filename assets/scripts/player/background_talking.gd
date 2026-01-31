extends AudioStreamPlayer2D

#var player: Player
@export var player: Player
@export var audio : AudioStreamPlayer2D
@export var hearing_range = 600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func inside_hearing_range(crowd: Array, pos_player: Vector2) -> void:
	for person in crowd:
		var npc2d := person as Node2D
		if npc2d == null:
			continue # or print(person, " is not Node2D")
		var p: Vector2 = npc2d.global_position
		var distance := pos_player.distance_to(p)
		if(distance < hearing_range and !audio.playing):
			audio.play()
	pass
	
	
func outside_hearing_range(crowd: Array, pos_player: Vector2) -> void:
	var total = crowd.size()
	var count = 0
	for person in crowd:
		var npc2d := person as Node2D
		if npc2d == null:
			continue # or print(person, " is not Node2D")
		var p: Vector2 = npc2d.global_position
		var distance := pos_player.distance_to(p)
		if(distance > hearing_range):
			count += 1
	#print(count)
	if(count == total):
		audio.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var crowd = get_tree().get_nodes_in_group("Guards")
	#var player2d := player as Node2D
	#if player2d == null:
	#	push_error("player is not a Node2D")
	#	return

	#var pos_player: Vector2 = player2d.global_position
	#inside_hearing_range(crowd, pos_player)
	#outside_hearing_range(crowd, pos_player)
