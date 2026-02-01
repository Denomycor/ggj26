## Move to a location to investigate the path along the way
class_name InvestigateCop extends State

var cop: Cop


func prepare() -> void:
	cop = owner as Cop


func enter(_previous_state: State, args) -> void:
	assert(args is Vector2)
	cop.nav_agent.target_position = args
	cop.investigating_sprite.visible = true
	cop.get_node("sprite_group").animation_player.play("move", -1, 0.7)
	cop.get_node("sprite_group").animation_player.seek(randf()*0.4)
	cop.get_node("notifier").play(cop.get_node("notifier").question_mark)


func physics_process(_delta: float) -> void:
	if(!cop.nav_agent.is_navigation_finished()):
		# spotted the player
		if(cop.is_player_seen()):
			state_machine.transition(self, "chasing", LevelContext.player)
			return

		var next_pos := cop.nav_agent.get_next_path_position()
		var direction := cop.position.direction_to(next_pos)
		cop.velocity = direction * cop.BASE_SPEED * cop.chase_speed_multiplier
		cop.move_and_slide()
		cop.set_cone_target(cop.nav_agent.target_position)
		cop.move_cone_towards_target(_delta, cop.base_cone_angular_speed * cop.chase_speed_multiplier)
	else:
		state_machine.transition(self, "patrolling")

func exit(_next_state: State) -> void:
	cop.investigating_sprite.visible = false
	cop.get_node("sprite_group").animation_player.stop()

