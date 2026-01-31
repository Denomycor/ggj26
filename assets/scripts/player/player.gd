class_name Player extends CharacterBody2D

@export var speed: float = 200.0
@onready var running_sfx: AudioStreamPlayer2D = $running_sfx
@onready var background_talking_sfx: AudioStreamPlayer2D = $background_talking_sfx
@onready var area2d: Area2D = $Area2D

#@onready var sprite: Sprite2D = $Sprite2D
var movement_state_machine := StateMachine.new(self)

func _ready() -> void:
	movement_state_machine.add_state(IdleState.new("idle_normal"))
	movement_state_machine.add_state(RunState.new("running"))
#	movement_state_machine.add_state(HidingMoveState.new("move_hiding"))
#	movement_state_machine.add_state(HidingIdleState.new("idle_hiding"))
	movement_state_machine.starting_state("idle_normal")


func _physics_process(delta: float) -> void:
	movement_state_machine.physics_process(delta)
	var shouldPlay = area2d.has_overlapping_bodies()
	if(shouldPlay and !background_talking_sfx.playing):
		print(shouldPlay)
		background_talking_sfx.play()
		print(background_talking_sfx.playing)
	else:
		background_talking_sfx.stop()
