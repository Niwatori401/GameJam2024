extends Node2D

var delay_seconds : float = 1;
var all_keys : Array[Enums.NEXT_KEY] = [Enums.NEXT_KEY.UP, Enums.NEXT_KEY.DOWN, Enums.NEXT_KEY.LEFT, Enums.NEXT_KEY.RIGHT]
var cur_key : Enums.NEXT_KEY;

var cur_seconds : float = 0;
var threshold_good : float = 0.9;

var cur_key_success := false;

func _ready() -> void:
	$BGM.fade_in(2);
	set_random_new_key();

func _process(delta: float) -> void:
	cur_seconds += delta;
	if cur_seconds > delay_seconds:
		cur_seconds -= delay_seconds;
		if not cur_key_success:
			# do something, fail sound at least
			pass
		
		set_random_new_key();
	
	$NextKeyIndicator.set_circle_progress(cur_seconds / delay_seconds);
	
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
	
func fail_cur_key():
	$NextKeyIndicator.set_to_fail_icon();
	cur_key_success = false;

func clear_current_success():
	$NextKeyIndicator.set_to_none_icon();
	cur_key_success = false;

func is_success(pressed_key_direction : Enums.NEXT_KEY) -> bool:
	if pressed_key_direction != cur_key:
		return false;
	
	if cur_seconds < threshold_good:
		return false;
		
	return true;

func set_random_new_key():
	cur_key = all_keys.pick_random();
	$NextKeyIndicator.set_next_key_texture(cur_key);
