extends AudioStreamPlayer2D

#var player: Player
var all_the_people

@export var player: Player
@export var audio : AudioStreamPlayer2D
@export var detection_area: Area2D
@export var hearing_range = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$crowd_background_noise_range.body_entered.connect(_on_area_2d_body_enter)
	#$crowd_background_noise_range.body_exited.connect(_on_area_2d_body_exited)
	pass # Replace with function body.

#func _on_area_2d_body_enter(body: Node2D) -> void:
#	if(body.is_in_group('NPCs') and !audio.playing):
#		audio.play()
#		print("enter")
#	pass
#func _on_area_2d_body_exited(body: Node2D) -> void:
#	while($crowd_background_noise_range.overlaps_body() body.is_in_group('NPCs')):
#		audio.stop()
##	pass

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
	print(total)
	var count = 0
	for person in crowd:
		var npc2d := person as Node2D
		if npc2d == null:
			continue # or print(person, " is not Node2D")
		var p: Vector2 = npc2d.global_position
		var distance := pos_player.distance_to(p)
		if(distance > hearing_range):
			count += 1
	if(count == total):
		audio.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var crowd = get_tree().get_nodes_in_group("NPCs")
	var player2d := player as Node2D
	if player2d == null:
		push_error("player is not a Node2D")
		return

	var pos_player: Vector2 = player2d.global_position
	inside_hearing_range(crowd, pos_player)
	outside_hearing_range(crowd, pos_player)
	
		
	pass
