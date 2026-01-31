class_name RunState extends State

var player: Player
# var isHidden: bool = false


func prepare() -> void:
	player = owner as Player

# func enter(previous_state: State) -> void:
	

func physics_process(delta: float) -> void:
	var x_axis := Input.get_axis("right", "left")
	var y_axis := Input.get_axis("down", "up")

	if(x_axis or y_axis):
		player.velocity.x = x_axis * player.speed * -1
		
#		player.sprite.sprite.flip_h = x_axis < 0

		player.velocity.y = y_axis * player.speed * -1
		player.move_and_slide()
	else:
		player.movement_state_machine.transition(self, "idle_normal")


func exit(next_state: State) -> void:
	player.velocity.x = 0
	# player.animation_player.stop()
