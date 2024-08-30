extends Node2D

# can be set [1, 3]
var minimum_key_presses_per_challenge = 1;
var maximum_key_presses_per_challenge = 1;


var seconds_per_day : float = 60;
var seconds_elapsed_total : float = 0;

var delay_seconds : float = 1;

var current_keys : Array[Enums.KEY_DIRECTION] = [];
@export var success_sounds : Array[AudioStream];
var cur_seconds : float = 0;

var day_to_button_map = {
	1: [Enums.KEY_DIRECTION.DOWN],
	2: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT],
	3: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT],
	4: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
	5: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
	6: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
	7: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
	8: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT],
	9: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT],
	10: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
	11: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
	12: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
	13: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
	14: [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT, Enums.KEY_DIRECTION.LEFT, Enums.KEY_DIRECTION.UP],
}

var day_to_max_arrows = {
	1: 1,
	2: 1,
	3: 1,
	4: 1,
	5: 1,
	6: 1,
	7: 1,
	8: 2,
	9: 2,
	10: 2,
	11: 2,
	12: 2,
	13: 3,
	14: 3,
}

var desk_item_to_unlock_day = {
	"Clipboard" : 1,
	"Stamp_1": 1,
	"Stamp_2": 2,
	"DeskButton": 3,
	"PneumaticTube": 4,
}

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

var cycle_used_stamps := false;
var player_hit_stamp_button_this_cycle := false;
var stamp_directions : Array[Enums.KEY_DIRECTION] = [Enums.KEY_DIRECTION.DOWN, Enums.KEY_DIRECTION.RIGHT];



func _ready() -> void:
	Inventory.get_save().load(Globals.USER_SAVE_FILE);
	day_number = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, 1);
	$Trinkets/ClientCam.visible = day_number >= 8;
		
	if day_number == 1:
		seconds_per_day = 30;
		
	maximum_key_presses_per_challenge = day_to_max_arrows.get(floori(day_number));
	show_only_unlocked_trinkets();
	show_only_appropriate_work_items();
	SignalBus.game_loss.connect(func() : 
		var first_hr_visit = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_IS_FIRST_HR_VISIT, true);
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
	if not is_loading and (Input.is_action_just_pressed("debug_12") or (Input.is_action_pressed("cheat_1") and Input.is_action_pressed("cheat_2") and Input.is_action_pressed("cheat_3"))):
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

func show_only_appropriate_work_items():
	for item_index in range(len(desk_item_to_unlock_day)):
		get_node(desk_item_to_unlock_day.keys()[item_index]).visible = day_number >= desk_item_to_unlock_day.values()[item_index];

func show_only_unlocked_trinkets():
	$Trinkets/ThrowBall.visible = Inventory.is_trinket_unlocked(Globals.TRINKET_BALL);
	$Trinkets/TrinketClock.visible = Inventory.is_trinket_unlocked(Globals.TRINKET_CLOCK);
	$Trinkets/KoboldTrinket.visible = Inventory.is_trinket_unlocked(Globals.TRINKET_KOBOLD);
	$Trinkets/BloopyPlush.visible = Inventory.is_trinket_unlocked(Globals.TRINKET_BLOOPY);


func set_correct_bgm(day_number : float) -> void:
	# Day 8
	if day_number >= 7:
		$BGM.stream = music_tracks[music_track_index_by_day.back()];
	else:
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

var group_three_cooldown : int = 0;
func set_random_new_keys():
	cycle_used_stamps = false;
	current_keys.clear();
	
	var num_of_keys : int;
	if group_three_cooldown > 0:
		num_of_keys = randi_range(minimum_key_presses_per_challenge, 2);
		group_three_cooldown -= 1;
	else:
		num_of_keys = randi_range(minimum_key_presses_per_challenge, maximum_key_presses_per_challenge);
	
	
	if num_of_keys == 1 or num_of_keys == 2:
		for i in range(num_of_keys):
			var cur_key = day_to_button_map.get(floori(day_number)).pick_random();
			cycle_used_stamps = cycle_used_stamps or cur_key == stamp_directions[0] or cur_key == stamp_directions[1];
			current_keys.append(cur_key);
		
	elif num_of_keys == 3:
		const NUM_TO_WAIT_AFTER_3GROUP : int = 3;
		group_three_cooldown = NUM_TO_WAIT_AFTER_3GROUP;
		var first_key = day_to_button_map.get(floori(day_number)).pick_random();
		var second_key = day_to_button_map.get(floori(day_number)).pick_random();
		if day_number < 14:
			current_keys = [first_key, first_key, first_key];
		else:
			current_keys = [first_key, first_key, second_key];
	else:
		printerr("Invalid number of keys given in set_random_new_keys");
	
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
	is_loading = true;
	SignalBus.game_win.emit();
	$BGM.fade_out(2.5);
	get_tree().create_timer(2.5).timeout.connect(func(): $BGM.stop());
	$Fader.darken(3);
	$Trinkets/TrinketClock.stop_clock(true);
	
	
	if not is_prelunch() or day_number == 1:
		$EndOfDaySound.play();
		if day_number == 1:
			Inventory.get_save().set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, day_number + 1);
		else:
			Inventory.get_save().set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, day_number + 0.5);
		Inventory.change_and_commit_money_amount(5);
		
		if day_number >= 8:
			Utility.load_scene(2, Globals.SCENE_END_OF_DAY_PRE_MAIN_GAME);
		else:
			Utility.load_scene(3, Globals.SCENE_PRE_MAIN_GAME);
	else:
		$LunchTimeSound.play();
		Inventory.get_save().set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, day_number + 0.5);
		Inventory.get_save().save(Globals.USER_SAVE_FILE);
		Utility.load_scene(3, Globals.SCENE_PRE_LUNCH_MAIN_GAME);
	
	
