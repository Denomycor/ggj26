extends Node

const NUM_GROUPS: int = 12
const GROUP_SIZE_MIN: int = 5
const GROUP_SIZE_MAX: int = 8
const SPAWN_AREA_WIDTH: float = 9500.0
const SPAWN_AREA_HEIGHT: float = 5360.0
const GROUP_SPAWN_RADIUS: float = 500.0
const NEW_DESTINATION_CHANCE: float = 0.005
const UPDATE_INTERVAL: float = 1.0

const NPC_SCENE: PackedScene = preload("res://assets/scenes/npcs/npc.tscn")

var group_colors: Array[Color] = [
	Color.RED,
	Color.GREEN,
	Color.BLUE,
	Color.YELLOW,
	Color.PURPLE,
	Color.ORANGE,
	Color.BROWN,
	Color.PINK,
	Color.CYAN,
	Color.VIOLET,
	Color.INDIGO,
	Color.LIME,
	Color.MAROON,
	Color.OLIVE,
	Color.PINK,
]

## Spawns a new NPC instance with a modified color
func _spawn_colored_npc(color: Color) -> Npc:
	var npc: Npc = NPC_SCENE.instantiate()
	var sprite = npc.get_node("Sprite2D")
	sprite.modulate = color
	return npc


var groups: Array[Array] = []


func _ready() -> void:
	_spawn_npc_groups()


func _process(_delta: float) -> void:
	_update_group_destinations()
	pass 


## Spawns all NPC groups in random positions within the spawn area
func _spawn_npc_groups() -> void:
	for group_index in range(NUM_GROUPS):
		var group: Array[Npc] = []
		var group_size: int = randi_range(GROUP_SIZE_MIN, GROUP_SIZE_MAX)
		var group_center: Vector2 = _get_random_position_in_area()
		var group_color: Color = group_colors[group_index]

		for _i in range(group_size):
			var npc: Npc = _spawn_colored_npc(group_color)	
			# Spawn NPCs near the group center with some offset
			var spawn_offset := Vector2(
				randf_range(-GROUP_SPAWN_RADIUS, GROUP_SPAWN_RADIUS),
				randf_range(-GROUP_SPAWN_RADIUS, GROUP_SPAWN_RADIUS)
			)
			npc.position = group_center + spawn_offset
			add_child(npc)
			group.append(npc)
		
		groups.append(group)
		# Set initial destination for the group
		_set_group_destination(group, _get_random_position_in_area())


## Checks each group and assigns new destinations if they've reached their previous one
func _update_group_destinations() -> void:
	for group in groups:
		if _has_group_reached_destination(group):
			if randf() < NEW_DESTINATION_CHANCE:
				_set_group_destination(group, _get_random_position_in_area())


## Returns true if all NPCs in the group have reached their destination
func _has_group_reached_destination(group: Array) -> bool:
	for npc: Npc in group:
		if not npc.has_reached_destination():
			return false
	return true


## Sets the destination for all NPCs in a group with slight random offsets
func _set_group_destination(group: Array, destination: Vector2) -> void:
	for npc: Npc in group:
		# Add small offset so NPCs don't all pile on the exact same spot
		var offset := Vector2(
			randf_range(-GROUP_SPAWN_RADIUS, GROUP_SPAWN_RADIUS),
			randf_range(-GROUP_SPAWN_RADIUS, GROUP_SPAWN_RADIUS)
		)
		npc.set_destination(destination + offset)


## Returns a random position within the spawn area
func _get_random_position_in_area() -> Vector2:
	return Vector2(
		randf_range(0.0, SPAWN_AREA_WIDTH),
		randf_range(0.0, SPAWN_AREA_HEIGHT)
	)
