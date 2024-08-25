extends Node2D

# can be set [1, 3]
const MINIMUM_KEY_PRESSES_PER_CHALLENGE = 1;
const MAXIMUM_KEY_PRESSES_PER_CHALLENGE = 2;

var delay_seconds : float = 1;
var all_keys : Array[Enums.KEY_DIRECTION] = [Enums.KEY_DIRECTION.UP, Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.RIGHT]

var current_keys : Array[Enums.KEY_DIRECTION] = [];

@export var success_sounds : Array[AudioStream];

var cur_seconds : float = 0;
var threshold_good : float = 0.9;

var cur_key_success := false;
var keys_already_pressed_for_cycle := false;

var cur_pressed_keys : Array[Enums.KEY_DIRECTION] = [];

func _ready() -> void:
	$BGM.fade_in(2);
	set_random_new_keys();
	clear_current_success();
	

func _process(delta: float) -> void:
	cur_seconds += delta;
	if cur_seconds > delay_seconds:
		cur_seconds -= delay_seconds;
		if not cur_key_success:
			SignalBus.key_miss.emit();
			
		set_random_new_keys();
		clear_current_success();
	
	$NextKeyIndicator.set_circle_progress(cur_seconds / delay_seconds);
	
	if keys_already_pressed_for_cycle:
		return;
		
	if Input.is_action_just_pressed("Up"):
		handle_key_press(Enums.KEY_DIRECTION.UP);
	elif Input.is_action_just_pressed("Left"):
		handle_key_press(Enums.KEY_DIRECTION.LEFT);
	elif Input.is_action_just_pressed("Down"):
		handle_key_press(Enums.KEY_DIRECTION.DOWN);
	elif Input.is_action_just_pressed("Right"):
		handle_key_press(Enums.KEY_DIRECTION.RIGHT);

func handle_key_press(key : Enums.KEY_DIRECTION):
	cur_pressed_keys.append(key);
	var pressed_score : Array[int] = [0, 0, 0, 0];
	var assigned_score : Array[int] = [0, 0, 0, 0];
	
	for i in current_keys:
		assigned_score[i] += 1;
		
	for i in cur_pressed_keys:
		pressed_score[i] += 1;
	
	for i in range(len(assigned_score)):
		if pressed_score[i] > assigned_score[i]:
			fail_cur_challenge();
			return;
	
	play_success_sound(key);
	
	# Not finished yet, but everything right for now
	if len(cur_pressed_keys) < len(current_keys):
		return;
	
	succeed_cur_challenge();
	#play_success_sound(key);
	return;


func succeed_cur_challenge():
	$NextKeyIndicator.set_to_pass_icon();
	cur_key_success = true;
	keys_already_pressed_for_cycle = true;
	SignalBus.key_hit.emit();
	
func fail_cur_challenge():
	$NextKeyIndicator.set_to_fail_icon();
	cur_key_success = false;
	keys_already_pressed_for_cycle = true;
	SignalBus.key_miss.emit();


func clear_current_success():
	$NextKeyIndicator.set_to_none_icon();
	cur_key_success = false;
	keys_already_pressed_for_cycle = false;
	cur_pressed_keys.clear();


func play_success_sound(pressed_key_direction : Enums.KEY_DIRECTION) -> void:
	$SFX.stop();
	$SFX.stream = success_sounds[pressed_key_direction];
	$SFX.play();
	
func set_random_new_keys():
	current_keys.clear();
	var num_of_keys = randi_range(MINIMUM_KEY_PRESSES_PER_CHALLENGE, MAXIMUM_KEY_PRESSES_PER_CHALLENGE);
	for i in range(num_of_keys):
		current_keys.append(all_keys.pick_random());
	$NextKeyIndicator.set_next_key_texture(current_keys);

var paper_is_up := false;
func _on_clip_board_button_down() -> void:
	if paper_is_up:
		$Control/PaperMessage.start_move_down();
	else:
		$Control/PaperMessage.start_move_up();
	
	paper_is_up = !paper_is_up;
