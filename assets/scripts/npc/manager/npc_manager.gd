class_name NpcManager extends Node

@export var NUM_GROUPS := 4
@export var MIN_NPCS_PER_GROUP := 5
@export var MAX_NPCS_PER_GROUP := 8
@export var GROUP_AREA_RELATIVE_SIZE := 0.2
@export var CHANGE_DESTINATION_TIME := 5.0
@export var CHANGE_DESTINATION_TIME_VARIANCE := 2.0

@onready var spawn_area: Area2D = $spawn_area

const NPC_SCENE: PackedScene = preload("res://assets/scenes/npcs/npc.tscn")

enum GROUPS {
	NONE,
	RED,
	GREEN,
	BLUE,
	YELLOW,
}

const group_colors: Array[Color] = [
	Color.WHITE,
	Color.RED,
	Color.GREEN,
	Color.BLUE,
	Color.YELLOW,
	Color.PURPLE,
	Color.ORANGE,
	Color.BROWN,
	Color.CYAN,
	Color.VIOLET,
	Color.INDIGO,
	Color.LIME,
	Color.MAROON,
	Color.OLIVE,
	Color.PINK,
]


var groups: Dictionary[GROUPS, Array] = {}
var destinations: Dictionary[GROUPS, Area2D] = {}
var is_on_timer: Dictionary[GROUPS, bool] = {}

func _ready() -> void:
	_create_group_destination_areas()
	_spawn_npc_groups()

func _physics_process(_delta: float) -> void:
	for group in groups.keys():
		if _is_all_group_in_destination(group):
			if not is_on_timer.has(group) or not is_on_timer[group]:
				#start timer for new group destination with a tween
				var tween = create_tween()
				tween.tween_callback(func(): _set_group_destination(group, get_random_position_in_rectangle(spawn_area))).set_delay(CHANGE_DESTINATION_TIME + randf_range(-CHANGE_DESTINATION_TIME_VARIANCE, CHANGE_DESTINATION_TIME_VARIANCE))
				is_on_timer[group] = true
		else:
			is_on_timer[group] = false

func _is_all_group_in_destination(group: GROUPS) -> bool:
	if destinations.has(group):
		if destinations[group].get_overlapping_bodies().size() >= groups[group].size():
			return true
	return false

func _set_random_group_destination() -> void:
	for group_index in NUM_GROUPS+1:
		if group_index == GROUPS.NONE:
			continue
		_set_group_destination(group_index, get_random_position_in_rectangle(spawn_area))

func _create_group_destination_areas() -> void:
	for group_index in NUM_GROUPS+1:
		if group_index == GROUPS.NONE:
			continue
		var destination_area: Area2D = Area2D.new()
		var collision_shape: CollisionShape2D = CollisionShape2D.new()
		var shape: RectangleShape2D = RectangleShape2D.new()
		shape.size = Vector2($spawn_area/CollisionShape2D.shape.size.x * GROUP_AREA_RELATIVE_SIZE, $spawn_area/CollisionShape2D.shape.size.y * GROUP_AREA_RELATIVE_SIZE)
		collision_shape.shape = shape
		destination_area.global_position = get_random_position_in_rectangle(spawn_area)
		destination_area.collision_mask = 2
		add_child(destination_area)
		destination_area.add_child(collision_shape)
		destinations[group_index] = destination_area

## Spawns all NPC groups in random positions within the spawn area
func _spawn_npc_groups() -> void:
	for group_index in NUM_GROUPS+1:
		if group_index == GROUPS.NONE:
			continue
		var num_npcs: int = randi_range(MIN_NPCS_PER_GROUP, MAX_NPCS_PER_GROUP)
		groups[group_index] = []
		for i in num_npcs:
			var npc: Npc = _spawn_grouped_npc(group_index)
			npc.global_position = get_random_position_in_rectangle(destinations[group_index])
			npc.npc_manager = self
			npc.set_destination(npc.global_position)
			groups[group_index].append(npc)
			get_node("../world").add_child(npc)

## Spawns a new NPC instance with a modified color
func _spawn_grouped_npc(group: GROUPS) -> Npc:
	var npc: Npc = NPC_SCENE.instantiate()
	npc.get_node("sprite_group").change_mask_to_group(group)
	npc.group = group
	return npc

## sets position for destination areas of a given group
func _set_group_destination(group: GROUPS, destination: Vector2) -> void:
	if destinations.has(group):
		destinations[group].position = destination
		for npc in groups[group]:
			npc.set_destination(get_random_position_in_rectangle(destinations[group]))

## Returns a random position within the spawn area
func get_random_position_in_rectangle(area: Area2D) -> Vector2:
	var shape: RectangleShape2D = area.get_child(0).shape as RectangleShape2D
	return Vector2(
		randf_range(-shape.size.x * 0.5, shape.size.x * 0.5)+area.global_position.x,
		randf_range(-shape.size.y * 0.5, shape.size.y * 0.5)+area.global_position.y
	)

func _get_random_group() -> GROUPS:
	return randi_range(1, NUM_GROUPS) as GROUPS
