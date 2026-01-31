class_name IdleNpc extends State


var npc: Npc



func prepare() -> void:
	npc = owner as Npc
	
func enter(_previous_state: State, _args) -> void:
	npc.idle_talking_sfx.play()
	
func exit(_next_state: State) -> void:
	npc.idle_talking_sfx.stop()
