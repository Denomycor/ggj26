## Move the Npc to a given location
class_name FlockingNpc extends State

var npc: Npc
var cohesion_weight: float = 1
var separation_weight: float = 1.5
var max_force: float = 10.0

func prepare() -> void:
    npc = owner as Npc

func enter(_previous_state: State, _args) -> void:
    # Initialize velocity to random direction
    var angle: float = randf() * TAU
    npc.velocity = Vector2.RIGHT.rotated(angle) * npc.max_speed

func physics_process(_delta: float) -> void:
    print("cohesion: ", _get_cohesion())
    print("separation: ", _get_separation())
    var force: Vector2 = _get_cohesion() * cohesion_weight + _get_separation() * separation_weight
    npc.velocity += force / npc.mass * _delta
    npc.velocity = npc.velocity.normalized() * min(npc.velocity.length(), npc.max_speed)
    npc.move_and_slide()

func exit(_next_state: State) -> void:
    npc.velocity = Vector2.ZERO

func _get_cohesion() -> Vector2:
    var force : Vector2 = Vector2.ZERO
    var center_of_mass: Vector2 = Vector2.ZERO
    var group_members: Array = _get_group_members()
    print("Group Members: ", group_members.size())
    for neighbor in group_members:
        center_of_mass += neighbor.global_position
    center_of_mass /= max(1, group_members.size())
    if group_members.size() != 0:
        force = center_of_mass - npc.global_position
    return force.normalized()

func _get_separation() -> Vector2:
    var force: Vector2 = Vector2.ZERO
    var neighbors: Array = _get_neighbors()
    print("Neighbors: ", neighbors.size())
    for neighbor in neighbors:
        if neighbor.global_position.distance_to(npc.global_position) < npc.separation_distance:
            var diff: Vector2 = npc.global_position - neighbor.global_position
            force += diff.normalized() / diff.length()
    force /= max(1, neighbors.size())
    return force.normalized()

func _get_neighbors() -> Array:
    var neighbors: Array = []
    for body in npc.neighbor_area.get_overlapping_bodies():
        if body is Npc and body != npc or body is Player:
            neighbors.append(body)
    return neighbors

func _get_group_members() -> Array:
    var group_members: Array = []
    for body in npc.neighbor_area.get_overlapping_bodies():
        if body is Npc and body != npc or body is Player:
            if body.group == npc.group:
                group_members.append(body)
    return group_members