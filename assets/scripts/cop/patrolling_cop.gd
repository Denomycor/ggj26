# Wander through the map patrolling it
class_name PatrollingCop extends State


var cop: Cop


func prepare() -> void:
	cop = owner as Cop


func enter(_previous_state: State, _args) -> void:
	cop.cop_coordinator.register_cop(cop)
	cop.nav_agent.target_position = cop.current_patrolling_point.global_position


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
		pick_new_poi()


func exit(_next_state: State) -> void:
	cop.velocity = Vector2.ZERO
	cop.cop_coordinator.remove_cop(cop)


func pick_new_poi() -> void:
	cop.cop_coordinator.change_poi_cop(cop)
	cop.nav_agent.target_position = cop.current_patrolling_point.global_position
