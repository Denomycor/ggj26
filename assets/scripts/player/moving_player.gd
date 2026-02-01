class_name RunState extends State

var player: Player
# var isHidden: bool = false


func prepare() -> void:
	player = owner as Player

func enter(_previous_state: State, _args) -> void:
	player.get_node("sprite_group").animation_player.play("move", -1, 1.0)
	player.running_sfx.play()

# func enter(previous_state: State) -> void:
	

func physics_process(_delta: float) -> void:
	var x_axis := Input.get_axis("left", "right")
	var y_axis := Input.get_axis("up", "down")
	if(x_axis or y_axis):
		var motion := Vector2(x_axis, y_axis).normalized()
		player.velocity = motion * player.speed
		player.move_and_slide()
	else:
		player.movement_state_machine.transition(self, "idle_normal")


func exit(_next_state: State) -> void:
	player.velocity.x = 0
	player.get_node("sprite_group").animation_player.stop()
	
	player.running_sfx.stop()
	# player.animation_player.stop()
