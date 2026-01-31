## Move the Npc to a given location
class_name MovingNpc extends State

var npc: Npc

func prepare() -> void:
	npc = owner as Npc

func enter(_previous_state: State, _args) -> void:
	npc.get_node("sprite_group").animation_player.play("move", -1, 0.7)
	npc.get_node("sprite_group").animation_player.seek(randf()*0.4)

func physics_process(_delta: float) -> void:
	var cohesion_force: Vector2 = npc._get_cohesion_force() * npc.cohesion_weight
	var separation_force: Vector2 = npc._get_separation_force() * npc.separation_weight
	var destination_force: Vector2 = npc._get_destination_force() * npc.destination_weight
	
	var combined_force: Vector2 = (cohesion_force + separation_force + destination_force).normalized()
	var steer := combined_force * npc.max_speed - npc.velocity
	npc.velocity += steer * npc.sensitivity * _delta
	npc.velocity = npc.velocity.normalized() * min(npc.velocity.length(), npc.max_speed)
	npc.move_and_slide()


func exit(_next_state: State) -> void:
	npc.velocity = Vector2.ZERO
	npc.get_node("sprite_group").animation_player.stop()

