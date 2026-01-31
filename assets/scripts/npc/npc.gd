class_name Npc extends CharacterBody2D

const SPEED := 200.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var group : NpcManager.GROUPS

var state_machine := StateMachine.new(self)


func _ready() -> void:
	state_machine.add_state(MovingNpc.new("moving"))
	state_machine.add_state(IdleNpc.new("idle"))
	state_machine.starting_state("idle", null)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


## Sets a new destination for the NPC to move towards
func set_destination(destination: Vector2) -> void:
	state_machine.transition(state_machine.current_state, "moving", destination)


## Returns true if the NPC has reached its destination and is idle
func has_reached_destination() -> bool:
	return state_machine.current_state.name == "idle"
