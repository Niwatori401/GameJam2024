extends Control

const INITIAL_FADE_IN_DELAY := 3;
const FADE_TIME_BETWEEN_FRAMES := 0.5;
var cur_wait_time : float = 0;
var foreground_frame_index : int = 0;

@export var scene_to_load_upon_completion : String;

var cur_total_wait_time : float = 0;
var cur_fade_time : float = 0;

@export var frames : Array[Texture2D] = [];
@export var delays : Array[float] = [];

# Full of arrays of strings
@export var text : Array[Array] = [[]];

var is_ending := false;

var need_to_add_text := true;
var skip_frame := false;

func _ready() -> void:
	assert(len(delays) == len(frames));
	assert(len(delays) == len(text));
	$BGM.fade_in(2);
	$DynamicTextBox.visible = false;
	$Fader.lighten(INITIAL_FADE_IN_DELAY);
	$Foreground.texture = frames[0];

	if should_end_cutscene():
		return;
		
	$Background.texture = frames[foreground_frame_index + 1];

func should_end_cutscene():
	if foreground_frame_index == len(frames) - 1:
		return true;

func should_use_delays():
	return delays[foreground_frame_index] != 0;

func _process(delta: float) -> void:
	if should_use_delays():
		if Input.is_action_just_pressed("accept"):
			skip_frame = true;
			
		cur_wait_time += delta;
		
		if cur_wait_time >= get_cur_total_wait_time() or skip_frame:
			if should_end_cutscene():
				if not is_ending:
					$Fader.darken(2);
					$BGM.fade_out(2);
					Utility.load_scene(2, scene_to_load_upon_completion);
					is_ending = true;
				return;
			
			fadeout_and_increment(delta);
	else:
		show_text_box();
		if need_to_add_text:
			$DynamicTextBox.display_new_text(text[foreground_frame_index]);
			need_to_add_text = false;
			
		if Input.is_action_just_pressed("accept"):
			$DynamicTextBox.display_next_line();
		
		if $DynamicTextBox.is_finished():
				if should_end_cutscene():
					if not is_ending:
						$Fader.darken(2);
						$BGM.fade_out(2);
						Utility.load_scene(2, scene_to_load_upon_completion);
						is_ending = true;
					return;
					
				if fadeout_and_increment(delta):
					need_to_add_text = true;


# true if done fading out, false otherwise
func fadeout_and_increment(delta):
	$Foreground.modulate.a -= delta / FADE_TIME_BETWEEN_FRAMES;
	if $Foreground.modulate.a <= 0:
		$Foreground.texture = $Background.texture;
		$Foreground.modulate.a = 1;
		
		foreground_frame_index += 1;
		cur_wait_time = 0;
		skip_frame = false;
		
		if should_end_cutscene():
			return true;
			
		$Background.texture = frames[foreground_frame_index + 1];
		return true;
	
	return false;

func get_cur_total_wait_time() -> float:
	return delays[foreground_frame_index];

func hide_text_box():
	$DynamicTextBox.visible = false;

func show_text_box():
	$DynamicTextBox.visible = true;

func wait(secs : float):
	await get_tree().create_timer(secs).timeout;
