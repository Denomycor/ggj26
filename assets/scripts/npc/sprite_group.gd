class_name SpriteGroup extends Node2D

var is_front := true

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var front_arms: Texture2D
@export var front_legs: Texture2D
@export var front_torso: Texture2D
@export var front_mask: Texture2D

@export var back_arms: Texture2D
@export var back_legs: Texture2D
@export var back_torso: Texture2D
@export var back_mask: Texture2D


func _ready() -> void:
	$pivot/arms.texture = front_arms
	$pivot/legs.texture = front_legs
	$pivot/torso.texture = front_torso
	$pivot/mask.texture = front_mask


func set_facing_front(value: bool) -> void:
	if value:
		$pivot/arms.texture = front_arms
		$pivot/legs.texture = front_legs
		$pivot/torso.texture = front_torso
		$pivot/mask.texture = front_mask

	else:
		$pivot/arms.texture = back_arms
		$pivot/legs.texture = back_legs
		$pivot/torso.texture = back_torso
		$pivot/mask.texture = back_mask
