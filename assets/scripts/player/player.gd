class_name Player extends CharacterBody2D

@export var speed: float = 200.0
@export var mask_range: float = 400.0
@onready var running_sfx: AudioStreamPlayer2D = $running_sfx
@onready var background_talking_sfx: AudioStreamPlayer2D = $background_talking_sfx
@onready var sprite: Sprite2D = $Sprite2D
@onready var mask_area: Area2D = $mask_area

var movement_state_machine := StateMachine.new(self)
var mask_color := Color.WHITE
var group : NpcManager.GROUPS
var masked_in := false

func _ready() -> void:
	_set_mask_range(mask_range)
	_change_mask_color(mask_color)
	movement_state_machine.add_state(IdleState.new("idle_normal"))
	movement_state_machine.add_state(RunState.new("running"))
#	movement_state_machine.add_state(HidingMoveState.new("move_hiding"))
#	movement_state_machine.add_state(HidingIdleState.new("idle_hiding"))
	movement_state_machine.starting_state("idle_normal")
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_0 and event.keycode <= KEY_9:
			var group_num : int = event.keycode - KEY_0
			change_mask_group(group_num)
			LevelContext.overlay.mask_bar.change_slot(group_num)

func _physics_process(delta: float) -> void:
	movement_state_machine.physics_process(delta)
	_check_for_groups()

func change_mask_group(mask_group: NpcManager.GROUPS):
	group = mask_group
	_change_mask_color(NpcManager.group_colors[group])

func _change_mask_color(color: Color):
	sprite.modulate = color

func _set_mask_range(_range: float):
	mask_area.find_child("CollisionShape2D").shape.radius = _range

func _check_for_groups():
	var prev_masked_in = masked_in
	for body in mask_area.get_overlapping_bodies():
		if body is Npc:
			var npc: Npc = body
			if npc.group == group:
				masked_in = true
				if not prev_masked_in:
					print("Masked In")
				return
	masked_in = false
	if prev_masked_in:
		print("Not Masked In")

	if Input.is_physical_key_pressed(KEY_L):
		LevelContext.game_overlay.toggle_bucket_list.emit()
