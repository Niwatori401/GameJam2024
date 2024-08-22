extends Node2D

const MINIMUM_KEY_PRESSES_PER_CHALLENGE = 1;
const MAXIMUM_KEY_PRESSES_PER_CHALLENGE = 3;

var delay_seconds : float = 1;
var all_keys : Array[Enums.NEXT_KEY] = [Enums.NEXT_KEY.UP, Enums.NEXT_KEY.DOWN, Enums.NEXT_KEY.LEFT, Enums.NEXT_KEY.RIGHT]

var current_keys : Array[Enums.NEXT_KEY] = [];

@export var success_sounds : Array[AudioStream];

var cur_seconds : float = 0;
var threshold_good : float = 0.9;

var cur_key_success := false;
var keys_already_pressed_for_cycle := false;

var cur_pressed_keys : Array[Enums.NEXT_KEY] = [];

func _ready() -> void:
	$BGM.fade_in(2);
	set_random_new_keys();
	clear_current_success();
	
func _process(delta: float) -> void:
	cur_seconds += delta;
	if cur_seconds > delay_seconds:
		cur_seconds -= delay_seconds;
		if cur_key_success:
			pass
			#add pts or sth
		else:
			# some penalty or effect
			pass
		set_random_new_keys();
		clear_current_success();
	
	$NextKeyIndicator.set_circle_progress(cur_seconds / delay_seconds);
	
	if keys_already_pressed_for_cycle:
		return;
		
	if Input.is_action_just_pressed("Up"):
		handle_key_press(Enums.NEXT_KEY.UP);
	elif Input.is_action_just_pressed("Left"):
		handle_key_press(Enums.NEXT_KEY.LEFT);
	elif Input.is_action_just_pressed("Down"):
		handle_key_press(Enums.NEXT_KEY.DOWN);
	elif Input.is_action_just_pressed("Right"):
		handle_key_press(Enums.NEXT_KEY.RIGHT);

func handle_key_press(key : Enums.NEXT_KEY):
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
	
func fail_cur_challenge():
	$NextKeyIndicator.set_to_fail_icon();
	cur_key_success = false;
	keys_already_pressed_for_cycle = true;


func clear_current_success():
	$NextKeyIndicator.set_to_none_icon();
	cur_key_success = false;
	keys_already_pressed_for_cycle = false;
	cur_pressed_keys.clear();


func play_success_sound(pressed_key_direction : Enums.NEXT_KEY) -> void:
	$SFX.stop();
	$SFX.stream = success_sounds[pressed_key_direction];
	$SFX.play();
	
func set_random_new_keys():
	current_keys.clear();
	var num_of_keys = randi_range(MINIMUM_KEY_PRESSES_PER_CHALLENGE, MAXIMUM_KEY_PRESSES_PER_CHALLENGE);
	for i in range(num_of_keys):
		current_keys.append(all_keys.pick_random());
	$NextKeyIndicator.set_next_key_texture(current_keys);
