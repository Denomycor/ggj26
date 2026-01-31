class_name Cop extends CharacterBody2D

const BASE_SPEED := 200.0
const GAME_OVER_DIST := 200.0

@export var cone_angle: float = 60.0
@export var cone_distance: float = 300.0
@export var up_close_distance: float = 100.0
@export var base_cone_angular_speed: float = 120.0  # degrees per second
@export var chase_speed_multiplier: float = 1.5
# Cop must know about the coordinator before running _ready
@export var cop_coordinator: CopCoordinator

var current_patrolling_point: Node2D = null

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision_cone: Area2D = $vision_cone
@onready var investigating_sprite: Sprite2D = $Node2D/investigating_sprite
@onready var chasing_sprite: Sprite2D = $Node2D/chasing_sprite

var state_machine := StateMachine.new(self)
var target_cone_angle: float = 0.0

func _ready() -> void:
	_set_vision_cone(cone_angle, cone_distance)
	state_machine.add_state(PatrollingCop.new("patrolling"))
	state_machine.add_state(InvestigateCop.new("investigate"))
	state_machine.add_state(ChasingCop.new("chasing"))
	state_machine.starting_state("patrolling")


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)

func face_cone_forward(offset: float = 0.0) -> void:
	vision_cone.rotation = velocity.angle() + deg_to_rad(offset)

func face_cone_towards(target_pos: Vector2, offset: float = 0.0) -> void:
	var direction: Vector2 = target_pos - global_position
	vision_cone.rotation = direction.angle() + deg_to_rad(offset)

func set_cone_target(target_pos: Vector2) -> void:
	var direction: Vector2 = target_pos - global_position
	target_cone_angle = direction.angle()

func move_cone_towards_target(delta: float, angular_speed: float) -> void:
	var current_angle: float = vision_cone.rotation
	var angle_diff: float = wrapf(target_cone_angle - current_angle, -PI, PI)
	var max_angle_change: float = deg_to_rad(angular_speed) * delta

	if abs(angle_diff) <= max_angle_change:
		vision_cone.rotation = target_cone_angle
	else:
		vision_cone.rotation += sign(angle_diff) * max_angle_change

func _is_player_in_vision_cone() -> bool:
	for body in vision_cone.get_overlapping_bodies():
		if body is Player:
			return true
	return false

func is_player_seen() -> bool:
	if _is_player_in_vision_cone():
		var player: Player = LevelContext.player
		if player.masked_in:
			var distance_to_player: float = global_position.distance_to(player.global_position)
			if distance_to_player < up_close_distance:
				return true
			return false
		return true
	return false

#set vision cones polygon points based on angle and distance
func _set_vision_cone(angle: float, distance: float) -> void:
	var points := PackedVector2Array()
	points.append(Vector2.ZERO)
	points.append(Vector2(distance,distance*sin(deg_to_rad(angle/2))))
	points.append(Vector2(distance,distance*sin(deg_to_rad(-angle/2))))
	vision_cone.get_node("CollisionPolygon2D").polygon = points
