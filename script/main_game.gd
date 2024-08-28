extends Node2D

# can be set [1, 3]
const MINIMUM_KEY_PRESSES_PER_CHALLENGE = 1;
const MAXIMUM_KEY_PRESSES_PER_CHALLENGE = 1;


var seconds_per_day : float = 60;
var seconds_elapsed_total : float = 0;

var delay_seconds : float = 1;
#var all_game_keys : Array[Enums.KEY_DIRECTION] = [Enums.KEY_DIRECTION.UP, Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.RIGHT]
var all_game_keys : Array[Enums.KEY_DIRECTION] = [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP]

var current_keys : Array[Enums.KEY_DIRECTION] = [];
@export var success_sounds : Array[AudioStream];
var cur_seconds : float = 0;

var music_tracks : Array[AudioStream] = [
	preload("res://asset/sound/clock_2s.ogg"),
	preload("res://asset/sound/DAY 2.ogg"),
	preload("res://asset/sound/DAY 3.ogg"),
	preload("res://asset/sound/DAY 4.ogg"),
	preload("res://asset/sound/DAY 5.ogg"),
	preload("res://asset/sound/DAY 6.ogg"),
	preload("res://asset/sound/DAY 7.ogg")
]

var music_track_index_by_day : Array[int] = [
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	6,
	6,
	6,
	6,
	6,
	6,
	6,	
]

var cur_key_success := false;
var keys_already_pressed_for_cycle := false;

var cur_pressed_keys : Array[Enums.KEY_DIRECTION] = [];
var game_over := false;

# starts at 1, not 0
var day_number : float = 1;
var saveFile = ConfigFile.new();

var cycle_used_stamps := false;
var player_hit_stamp_button_this_cycle := false;
var stamp_directions : Array[Enums.KEY_DIRECTION] = [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT];


func _ready() -> void:
	saveFile.load(Globals.USER_SAVE_FILE);
	day_number = saveFile.get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, 1);
	
	SignalBus.game_loss.connect(func() : 
		var first_hr_visit = saveFile.get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_HAD_FIRST_HR_VISIT, true);
		game_over = true;
		
		if first_hr_visit:
			Utility.load_scene(3, Globals.SCENE_HR_FIRST_TIME_CUTSCENE);
		else:
			Utility.load_scene(3, Globals.SCENE_GAME_OVER);
		$BGM.fade_out(2.5);
		get_tree().create_timer(2.5).timeout.connect(func(): $BGM.stop());
		$Fader.darken(2.5);
		$Trinkets/TrinketClock.stop_clock();
		);
	$Fader.lighten(1);
	set_correct_bgm(day_number);
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
		if not cur_key_success and not keys_already_pressed_for_cycle:
			SignalBus.key_challenge_fail.emit();
			
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

func set_correct_bgm(day_number : float) -> void:
	if day_number >= 14:
		$BGM.stream = music_tracks[music_track_index_by_day.back()];
		return;
		
	$BGM.stream = music_tracks[floori(day_number) - 1];
	$BGM.stream.loop = true;
	$BGM.play();
	return;

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
			
	if key == stamp_directions[0] or key == stamp_directions[1]:
		player_hit_stamp_button_this_cycle = true;
	
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
	if cycle_used_stamps:
		get_tree().create_timer(0.66).timeout.connect(func(): 
			$Stamp_1.stop()
			$Stamp_2.stop();
			$Clipboard.cycle_clipboard_animation());
	
	
func fail_cur_challenge():
	$NextKeyIndicator.set_to_fail_icon();
	cur_key_success = false;
	if cycle_used_stamps:
		get_tree().create_timer(0.66).timeout.connect(func(): 
			$Stamp_1.stop()
			$Stamp_2.stop();
			$Clipboard.cycle_clipboard_animation());
	keys_already_pressed_for_cycle = true;
	SignalBus.key_challenge_fail.emit();


func clear_current_success():
	$NextKeyIndicator.set_to_none_icon();
	cur_key_success = false;
	player_hit_stamp_button_this_cycle = false;
	keys_already_pressed_for_cycle = false;
	cur_pressed_keys.clear();


func play_success_sound(pressed_key_direction : Enums.KEY_DIRECTION) -> void:
	$SFX.stop();
	$SFX.stream = success_sounds[pressed_key_direction];
	$SFX.play();
	
func set_random_new_keys():
	cycle_used_stamps = false;
	current_keys.clear();
	var num_of_keys = randi_range(MINIMUM_KEY_PRESSES_PER_CHALLENGE, MAXIMUM_KEY_PRESSES_PER_CHALLENGE);
	for i in range(num_of_keys):
		var cur_key = all_game_keys.pick_random();
		cycle_used_stamps = cycle_used_stamps or cur_key == stamp_directions[0] or cur_key == stamp_directions[1];
		current_keys.append(cur_key);
	$NextKeyIndicator.set_next_key_texture(current_keys);

func play_success_animation(key_direction : Enums.KEY_DIRECTION):
	if key_direction == Enums.KEY_DIRECTION.DOWN:
		$Stamp_1.play("stamp1");
	elif key_direction == Enums.KEY_DIRECTION.RIGHT:
		$Stamp_2.play("stamp2");
	elif key_direction == Enums.KEY_DIRECTION.LEFT:
		$DeskButton.play("press_button");
	elif key_direction == Enums.KEY_DIRECTION.UP:
		$PneumaticTube.play("shoot_tube");
	else:
		printerr("Unknown button in play_success_animation");
	
func is_prelunch() -> bool:
	return abs(day_number - roundi(day_number)) < 0.002;
	

func succeed_shift():
	if day_number == 1:
		SignalBus.game_win.emit();
		is_loading = true;
		$EndOfDaySound.play();
		$BGM.fade_out(2.5);
		get_tree().create_timer(2.5).timeout.connect(func(): $BGM.stop());
		saveFile.set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, day_number + 1);
		saveFile.save(Globals.USER_SAVE_FILE);
		$Fader.darken(3);
		$Trinkets/TrinketClock.stop_clock(true);
		Utility.load_scene(3, Globals.SCENE_PRE_MAIN_GAME);
		return;
	
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
	$Trinkets/TrinketClock.stop_clock(true);
	
