class_name Npc extends CharacterBody2D


const SPEED := 200.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var state_machine := StateMachine.new(self)


func _ready() -> void:
	state_machine.add_state(MovingNpc.new("moving"))
	state_machine.add_state(IdleNpc.new("idle"))
	state_machine.starting_state("moving", Vector2.ZERO)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)

