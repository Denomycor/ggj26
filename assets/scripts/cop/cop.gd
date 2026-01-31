class_name Cop extends CharacterBody2D


const BASE_SPEED := 200.0
const GAME_OVER_DIST := 200.0

@export var cop_coordinator: CopCoordinator
var current_patrolling_point: Node2D = null

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision_cone: Area2D = $vision_cone

var state_machine := StateMachine.new(self)


func _ready() -> void:
	state_machine.add_state(PatrollingCop.new("patrolling"))
	state_machine.add_state(InvestigateCop.new("investigate"))
	state_machine.add_state(ChasingCop.new("chasing"))
	state_machine.starting_state("patrolling")


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
