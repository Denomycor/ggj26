class_name Npc extends CharacterBody2D

const SPEED := 200.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var neighbor_radius: float = 0
@export var separation_distance: float = 50.0
@export var max_speed: float = 300.0
@export var mass: float = 0.0001

@onready var neighbor_area: Area2D = $neighbor_area

var group : NpcManager.GROUPS

var state_machine := StateMachine.new(self)


func _ready() -> void:
	_set_neighbor_range(neighbor_radius)
	state_machine.add_state(MovingNpc.new("moving"))
	state_machine.add_state(IdleNpc.new("idle"))
	state_machine.add_state(FlockingNpc.new("flocking"))
	state_machine.starting_state("flocking", null)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


## Sets a new destination for the NPC to move towards
func set_destination(destination: Vector2) -> void:
	state_machine.transition(state_machine.current_state, "moving", destination)


## Returns true if the NPC has reached its destination and is idle
func has_reached_destination() -> bool:
	return state_machine.current_state.name == "idle"

func _set_neighbor_range(_range: float):
	neighbor_area.find_child("CollisionShape2D").shape.radius = _range