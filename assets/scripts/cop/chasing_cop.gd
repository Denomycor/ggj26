## Chase the player until it catches it or looses sight
class_name ChasingCop extends State


var cop: Cop
var target: Node2D
var path_timer: Timer

var target_last_know_pos: Vector2


func prepare() -> void:
	cop = owner as Cop
	path_timer = cop.get_node("pathTimer")
	path_timer.timeout.connect(set_target_path)


func enter(_previous_state: State, args) -> void:
	target = args
	set_target_path()
	target_last_know_pos = target.global_position
	path_timer.start()
	cop.chasing_sprite.visible = true
	cop.get_node("sprite_group").animation_player.play("move", -1, 0.7)
	cop.get_node("sprite_group").animation_player.seek(randf()*0.4)
	cop.get_node("notifier").play(cop.get_node("notifier").exclamation_mark)
	cop.chasing_sfx.play()


func physics_process(_delta: float) -> void:
	if(cop.global_position.distance_to(target.global_position) < cop.GAME_OVER_DIST && target is Player):
		LevelContext.game_over.trigger_game_over()
		pass

	# I see the enemy chase its position
	if(cop.is_player_seen()):
		var next_pos := cop.nav_agent.get_next_path_position()
		var direction := cop.position.direction_to(next_pos)
		cop.velocity = direction * cop.BASE_SPEED * cop.chase_speed_multiplier
		cop.move_and_slide()
		cop.set_cone_target(target.global_position)
		cop.move_cone_towards_target(_delta, cop.base_cone_angular_speed * cop.chase_speed_multiplier)
		target_last_know_pos = target.global_position

	# I don't see the enemy investigate the last know pos
	else:
		state_machine.transition(self, "investigate", target_last_know_pos)
		return


func exit(_next_state: State) -> void:
	path_timer.stop()
	cop.chasing_sprite.visible = false
	cop.get_node("sprite_group").animation_player.stop()


func set_target_path() -> void:
	cop.nav_agent.target_position = target.global_position
