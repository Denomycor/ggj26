class_name HoveringNpc extends State

var npc: Npc
enum inner_state { HOVERING, PAUSING }
var current_inner_state: inner_state = inner_state.HOVERING
var state_timer: Timer

func prepare() -> void:
    npc = owner as Npc
    state_timer = Timer.new()
    state_timer.timeout.connect(_on_state_timer_timeout)

func enter(_previous_state: State, _args) -> void:
    state_timer.start(2.0+randf()*2.0)

func physics_process(_delta: float) -> void:
    if current_inner_state == inner_state.HOVERING:
        npc.set_destination(npc.npc_manager.get_random_position_in_rectangle(npc.npc_manager.destinations[npc.group]))
        var separation_force: Vector2 = npc._get_separation_force() * npc.separation_weight
        var destination_force: Vector2 = npc._get_destination_force() * npc.destination_weight
        
        var combined_force: Vector2 = (separation_force + destination_force).normalized()
        var steer : Vector2= combined_force * npc.max_speed - npc.velocity
        npc.velocity += steer * npc.sensitivity * _delta
        npc.velocity = npc.velocity.normalized() * min(npc.velocity.length(), npc.max_speed)
        npc.move_and_slide()
    if current_inner_state == inner_state.PAUSING:
        npc.velocity = Vector2.ZERO
    if not npc.am_in_destination():
        npc.state_machine.transition(self,"moving", null)

func exit(_next_state: State) -> void:
    npc.velocity = Vector2.ZERO
    state_timer.stop()

func _on_state_timer_timeout() -> void:
    if current_inner_state == inner_state.HOVERING:
        current_inner_state = inner_state.PAUSING
        state_timer.start(1.0+randf()*1.0)
    else:
        current_inner_state = inner_state.HOVERING
        state_timer.start(2.0+randf()*2.0)