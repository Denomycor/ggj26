class_name IdleState extends State
var player: Player

	

# func enter(previous_state: State) -> void:
	# player.animation_player.play("idle_normal")
	# player.sprite.sprite.frame = 0


func physics_process(_delta: float) -> void:
	var x_axis := Input.get_axis("right", "left")
	var y_axis := Input.get_axis("down", "up")

	if(x_axis or y_axis):
		owner.movement_state_machine.transition(self, "running")
