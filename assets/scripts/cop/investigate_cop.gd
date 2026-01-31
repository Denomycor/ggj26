## Move to a location to investigate the path along the way
class_name InvestigateCop extends State

var cop: Cop


func prepare() -> void:
	cop = owner as Cop


func enter(_previous_state: State, args) -> void:
	assert(args is Vector2)
	cop.nav_agent.target_position = args


func physics_process(_delta: float) -> void:
	if(!cop.nav_agent.is_navigation_finished()):
		# spotted the player
		if(cop.vision_cone.has_overlapping_bodies()):
			state_machine.transition(self, "chasing", LevelContext.player)
			return

		var next_pos := cop.nav_agent.get_next_path_position()
		var direction := cop.position.direction_to(next_pos)
		cop.velocity = direction * cop.BASE_SPEED
		cop.move_and_slide()
	else:
		state_machine.transition(self, "patrolling")


func exit(_next_state: State) -> void:
	cop.velocity = Vector2.ZERO

