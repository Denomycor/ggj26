class_name MovingNpc extends State

var npc: Npc

func prepare() -> void:
	npc = owner as Npc


func enter(_previous_state: State, args) -> void:
	assert(args is Vector2)
	npc.nav_agent.target_position = args


func physics_process(_delta: float) -> void:
	if(!npc.nav_agent.is_navigation_finished()):
		var next_pos := npc.nav_agent.get_next_path_position()
		var direction := npc.position.direction_to(next_pos)
		npc.velocity = direction * npc.SPEED
		npc.move_and_slide()
	else:
		state_machine.transition(self, "idle")


func exit(_next_state: State) -> void:
	npc.velocity = Vector2.ZERO
