# Wander through the map patrolling it
class_name PatrollingCop extends State


var cop: Cop


func prepare() -> void:
	cop = owner as Cop


func physics_process(_delta: float) -> void:
	pass

