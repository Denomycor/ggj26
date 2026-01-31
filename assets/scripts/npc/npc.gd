class_name Npc extends CharacterBody2D

const SPEED := 200.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var neighbor_radius: float = 0
@export var separation_distance: float = 50.0
@export var max_speed: float = 250
@export var cohesion_weight: float = 1
@export var separation_weight: float = 1
@export var destination_weight: float = 0.5
@export var sensitivity: float = 10

var npc_manager: NpcManager

var destination: Vector2 = Vector2.ZERO

@onready var neighbor_area: Area2D = $neighbor_area

var group : NpcManager.GROUPS

var state_machine := StateMachine.new(self)

func _ready() -> void:
	_set_neighbor_range(neighbor_radius)
	state_machine.add_state(MovingNpc.new("moving"))
	state_machine.starting_state("moving", null)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)

func _set_neighbor_range(_range: float):
	neighbor_area.find_child("CollisionShape2D").shape.radius = _range

func _get_cohesion_force() -> Vector2:
	var force : Vector2 = Vector2.ZERO
	var center_of_mass: Vector2 = Vector2.ZERO
	var group_members: Array = _get_group_members()
	for neighbor in group_members:
		center_of_mass += neighbor.global_position
	center_of_mass /= max(1, group_members.size())
	if group_members.size() != 0:
		force = center_of_mass - global_position
	return force.normalized()

func _get_separation_force() -> Vector2:
	var force: Vector2 = Vector2.ZERO
	var neighbors: Array = _get_neighbors()
	for neighbor in neighbors:
		if neighbor.global_position.distance_to(global_position) < separation_distance:
			var diff: Vector2 = global_position - neighbor.global_position
			force += diff.normalized() / diff.length()
	force /= max(1, neighbors.size())
	return force.normalized()

func _get_destination_force() -> Vector2:
	var force: Vector2 = destination - global_position
	return force.normalized()

func _get_neighbors() -> Array:
	var neighbors: Array = []
	for body in neighbor_area.get_overlapping_bodies():
		if body is Npc and body != self or body is Player:
			neighbors.append(body)
	return neighbors

func _get_group_members() -> Array:
	var group_members: Array = []
	for body in neighbor_area.get_overlapping_bodies():
		if body is Npc and body != self or body is Player:
			if body.group == group:
				group_members.append(body)
	return group_members

func set_destination(new_destination: Vector2) -> void:
	destination = new_destination

func am_in_destination() -> bool:
	var destination_area = npc_manager.destinations[group]
	if destination_area.get_overlapping_bodies().has(self):
		return true
	return false
