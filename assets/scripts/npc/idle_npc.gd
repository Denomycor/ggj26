class_name IdleNpc extends State


var npc: Npc


func prepare() -> void:
	npc = owner as Npc


func enter(_previous_state: State, _args) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass
