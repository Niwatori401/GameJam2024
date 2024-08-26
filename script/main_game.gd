extends Node2D

# can be set [1, 3]
const MINIMUM_KEY_PRESSES_PER_CHALLENGE = 1;
const MAXIMUM_KEY_PRESSES_PER_CHALLENGE = 2;


var seconds_per_day : float = 60;
var seconds_elapsed_total : float = 0;

var delay_seconds : float = 1;
var all_game_keys : Array[Enums.KEY_DIRECTION] = [Enums.KEY_DIRECTION.UP, Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.RIGHT]

var current_keys : Array[Enums.KEY_DIRECTION] = [];
@export var success_sounds : Array[AudioStream];
var cur_seconds : float = 0;



var cur_key_success := false;
var keys_already_pressed_for_cycle := false;

var cur_pressed_keys : Array[Enums.KEY_DIRECTION] = [];
var game_over := false;

# starts at 1, not 0
var day_number : float = 1;
var saveFile = ConfigFile.new();

func _ready() -> void:
	saveFile.load(Globals.USER_SAVE_FILE);
	day_number = saveFile.get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, 1);
	
	SignalBus.game_loss.connect(func() : 
		game_over = true;
		Utility.load_scene(3, Globals.SCENE_GAME_OVER);
		$BGM.fade_out(2.5);
		get_tree().create_timer(2.5).timeout.connect(func(): $BGM.stop());
		$Fader.darken(2.5);
		$Trinkets/TrinketClock.stop_clock();
		);
	$Fader.lighten(1);
	$BGM.fade_in(2);
	set_random_new_keys();
	clear_current_success();
	
var is_loading := false;
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_12"):
		succeed_shift();
		
	if game_over or is_loading:
		return;
	
	seconds_elapsed_total += delta;
	if seconds_elapsed_total >= seconds_per_day:
		succeed_shift();
		return;
		
	
	
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
	
	play_success_animation(key);
	play_success_sound(key);
	
	# The player is not finished yet, but everything right for now
	if len(cur_pressed_keys) < len(current_keys):
		return;
	
	succeed_cur_challenge();
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
		current_keys.append(all_game_keys.pick_random());
	$NextKeyIndicator.set_next_key_texture(current_keys);

func play_success_animation(key_direction : Enums.KEY_DIRECTION):
	if key_direction == Enums.KEY_DIRECTION.UP:
		$Clipboard.cycle_clipboard_animation();
	
func is_prelunch() -> bool:
	return abs(day_number - roundi(day_number)) < 0.002;
	

func succeed_shift():
	SignalBus.game_win.emit();
	is_loading = true;
	if is_prelunch():
		$LunchTimeSound.play();
		Utility.load_scene(3, Globals.SCENE_PRE_LUNCH_MAIN_GAME);
	else:
		$EndOfDaySound.play();
		Utility.load_scene(3, Globals.SCENE_PRE_MAIN_GAME);
	
	$BGM.fade_out(2.5);
	get_tree().create_timer(2.5).timeout.connect(func(): $BGM.stop());

	saveFile.set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, day_number + 0.5);
	saveFile.save(Globals.USER_SAVE_FILE);
	
	$Fader.darken(3);
	# play sound for lunch time
	$Trinkets/TrinketClock.stop_clock(true);
	
