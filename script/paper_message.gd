extends Control

var time_to_move : float = 0.65;
var cur_time : float = 0;

var is_moving : bool = false;
var moving_up : bool = true;

func _ready() -> void:
	visible = false;


func _process(delta: float) -> void:
	if not is_moving:
		return;
	
	cur_time += delta;
	if cur_time >= time_to_move:
		if moving_up:
			position[1] = 0;
		else:
			position[1] = get_window().size[1];
			visible = false;
			
		cur_time = 0;
		is_moving = false;
		return;
		
	
	
	if moving_up:
		position[1] = get_window().size[1] * (1 - (cur_time / time_to_move));
	else:
		position[1] = get_window().size[1] * (cur_time / time_to_move);

func set_text(text_to_display : String) -> void:
	$Paper/LetterText.text = text_to_display;

func start_move_down(time_to_move_paper : float = 0.65) -> void:
	time_to_move = time_to_move_paper;
	visible = true;
	moving_up = false;
	is_moving = true;
	position[1] = 0;

func start_move_up(time_to_move_paper : float = 0.65) -> void:
	time_to_move = time_to_move_paper;
	visible = true;
	moving_up = true;
	is_moving = true;
	position[1] = get_window().size[1];
