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


func update_mask() -> void:
	if is_front:
		$pivot/mask.texture = front_mask
	else:
		$pivot/mask.texture = back_mask
	$maskPlayer.play("mask")
	

func change_mask_to_group(group: NpcManager.GROUPS) -> void:
	if(group == NpcManager.GROUPS.RED):
		back_mask = preload("res://assets/images/npc/masks/back_mask_1.png")
		front_mask = preload("res://assets/images/npc/masks/front_mask_1.png")
	elif(group == NpcManager.GROUPS.GREEN):
		back_mask = preload("res://assets/images/npc/masks/back_mask_2.png")
		front_mask = preload("res://assets/images/npc/masks/front_mask_2.png")
	elif(group == NpcManager.GROUPS.BLUE):
		back_mask = preload("res://assets/images/npc/masks/back_mask_3.png")
		front_mask = preload("res://assets/images/npc/masks/front_mask_3.png")
	elif(group == NpcManager.GROUPS.YELLOW):
		back_mask = preload("res://assets/images/npc/masks/back_mask_4.png")
		front_mask = preload("res://assets/images/npc/masks/front_mask_4.png")

