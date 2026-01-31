## CopCoordinator keeps track and assigns points to cops to be patrolled, add Node2D in the editor as children to create no points
class_name CopCoordinator extends Node2D


var poi_dict := {}


func _ready() -> void:
	init_poi_dict()


func init_poi_dict() -> void:
	for c in get_children():
		poi_dict[c] = []


func get_least_patrolled(exclude: Node2D = null) -> Node2D:
	var res: Node2D = poi_dict.keys()[0] if exclude != poi_dict.keys()[0] else poi_dict.keys()[1]
	for k in poi_dict:
		if(k != exclude):
			if poi_dict[res].size() > poi_dict[k].size():
				res = k
	return res


# Use to register a new cop to patrolling and assign it a point
func register_cop(cop: Cop, exclude: Node2D = null) -> void:
	var chosen_poi = get_least_patrolled(exclude)
	cop.current_patrolling_point = chosen_poi
	poi_dict[chosen_poi].append(cop)


# Use to remove a cop from patrolling
func remove_cop(cop: Cop) -> void:
	poi_dict[cop.current_patrolling_point].erase(cop)
	cop.current_patrolling_point = null


# Pick a new patrolling point to cop
func change_poi_cop(cop: Cop) -> void:
	var last_poi = cop.current_patrolling_point
	remove_cop(cop)
	register_cop(cop, last_poi)

