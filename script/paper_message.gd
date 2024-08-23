extends Control

const SECS_TO_FINISH_MOVEMENT : float = 0.65;
var cur_time : float = 0;

var is_moving : bool = false;
var moving_up : bool = true;

func _ready() -> void:
	visible = false;


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_1"):
		start_move_up();
	elif Input.is_action_just_pressed("debug_2"):
		start_move_down();
	
	if not is_moving:
		return;
	
	cur_time += delta;
	if cur_time >= SECS_TO_FINISH_MOVEMENT:
		if moving_up:
			position[1] = 0;
		else:
			position[1] = get_window().size[1];
			visible = false;
			
		cur_time = 0;
		is_moving = false;
		return;
		
	
	
	if moving_up:
		position[1] = get_window().size[1] * (1 - (cur_time / SECS_TO_FINISH_MOVEMENT));
	else:
		position[1] = get_window().size[1] * (cur_time / SECS_TO_FINISH_MOVEMENT);
	
func start_move_down():
	visible = true;
	moving_up = false;
	is_moving = true;
	position[1] = 0;

func start_move_up():
	visible = true;
	moving_up = true;
	is_moving = true;
	position[1] = get_window().size[1];
