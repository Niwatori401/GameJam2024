extends Node2D

var delay_seconds : float = 1;
var all_keys : Array[Enums.NEXT_KEY] = [Enums.NEXT_KEY.UP, Enums.NEXT_KEY.DOWN, Enums.NEXT_KEY.LEFT, Enums.NEXT_KEY.RIGHT]
var cur_key : Enums.NEXT_KEY;

@export var success_sounds : Array[AudioStream];

var cur_seconds : float = 0;
var threshold_good : float = 0.9;

var cur_key_success := false;
var key_already_pressed_for_cycle := false;

func _ready() -> void:
	$BGM.fade_in(2);
	set_random_new_key();
	clear_current_success();
	
func _process(delta: float) -> void:
	cur_seconds += delta;
	if cur_seconds > delay_seconds:
		cur_seconds -= delay_seconds;
		if cur_key_success:
			play_success_sound(cur_key);
		else:
			pass
		set_random_new_key();
		clear_current_success();
	
	$NextKeyIndicator.set_circle_progress(cur_seconds / delay_seconds);
	
	if key_already_pressed_for_cycle:
		return;
		
	if Input.is_action_just_pressed("Up"):
		if is_success(Enums.NEXT_KEY.UP):
			succeed_cur_key();
		else:
			fail_cur_key();
	elif Input.is_action_just_pressed("Left"):
		if is_success(Enums.NEXT_KEY.LEFT):
			succeed_cur_key();
		else:
			fail_cur_key();
	elif Input.is_action_just_pressed("Down"):
		if is_success(Enums.NEXT_KEY.DOWN):
			succeed_cur_key();
		else:
			fail_cur_key();
	elif Input.is_action_just_pressed("Right"):
		if is_success(Enums.NEXT_KEY.RIGHT):
			succeed_cur_key();
		else:
			fail_cur_key();


func succeed_cur_key():
	$NextKeyIndicator.set_to_pass_icon();
	cur_key_success = true;
	key_already_pressed_for_cycle = true;
	
func fail_cur_key():
	$NextKeyIndicator.set_to_fail_icon();
	cur_key_success = false;
	key_already_pressed_for_cycle = true;


func clear_current_success():
	$NextKeyIndicator.set_to_none_icon();
	cur_key_success = false;
	key_already_pressed_for_cycle = false;

func is_success(pressed_key_direction : Enums.NEXT_KEY) -> bool:
	if pressed_key_direction != cur_key:
		return false;

	return true;
	
func play_success_sound(pressed_key_direction : Enums.NEXT_KEY) -> void:
	$SFX.stop();

	if pressed_key_direction == Enums.NEXT_KEY.UP:
		$SFX.stream = success_sounds[0];
	elif pressed_key_direction == Enums.NEXT_KEY.LEFT:
		$SFX.stream = success_sounds[1];
	elif pressed_key_direction == Enums.NEXT_KEY.DOWN:
		$SFX.stream = success_sounds[2];
	elif pressed_key_direction == Enums.NEXT_KEY.RIGHT:
		$SFX.stream = success_sounds[3];

	$SFX.play();
	
func set_random_new_key():
	cur_key = all_keys.pick_random();
	$NextKeyIndicator.set_next_key_texture(cur_key);
