## Chase the player until it catches it or looses sight
class_name ChasingCop extends State


var cop: Cop
var target: Node2D
var path_timer: Timer
var chasing_raycast: RayCast2D

var target_last_know_pos: Vector2


func prepare() -> void:
	cop = owner as Cop
	path_timer = cop.get_node("pathTimer")
	chasing_raycast = cop.get_node("chasingRaycast")
	path_timer.timeout.connect(set_target_path)


func enter(_previous_state: State, args) -> void:
	target = args
	set_target_path()
	target_last_know_pos = target.global_position
	path_timer.start()
	chasing_raycast.enabled = true
	cop.get_node("sprite_group").animation_player.play("move", -1, 0.7)
	cop.get_node("sprite_group").animation_player.seek(randf()*0.4)


func physics_process(_delta: float) -> void:
	if(cop.global_position.distance_to(target.global_position) < cop.GAME_OVER_DIST && target is Player):
		# trigger game over
		pass

	# I see the enemy chase its position
	if(chasing_raycast.is_colliding()):
		var next_pos := cop.nav_agent.get_next_path_position()
		var direction := cop.position.direction_to(next_pos)
		cop.velocity = direction * cop.BASE_SPEED
		cop.move_and_slide()
		target_last_know_pos = target.global_position

	# I don't see the enemy investigate the last know pos
	else:
		state_machine.transition(self, "investigate", target_last_know_pos)
		return

	chasing_raycast.target_position = target.global_position - cop.global_position


func exit(_next_state: State) -> void:
	path_timer.stop()
	cop.velocity = Vector2.ZERO
	chasing_raycast.enabled = false
	cop.get_node("sprite_group").animation_player.stop()


func set_target_path() -> void:
	cop.nav_agent.target_position = target.global_position
