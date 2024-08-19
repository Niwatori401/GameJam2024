extends Control

const INITIAL_FADE_IN_DELAY := 3;
const FADE_TIME_BETWEEN_FRAMES := 0.5;
var cur_wait_time : float = 0;
var cur_frame_index : int = 0;

var cur_total_wait_time : float = 0;
var cur_fade_time : float = 0;

@export var frames : Array[Texture2D] = [];
@export var delays : Array[float] = [];

# Full of arrays of strings
@export var text : Array[Array] = [[]];
var should_end_cutscene := false;
var is_ending := false;

var need_to_add_text := true;

func _ready() -> void:
	assert(len(delays) == len(frames));
	assert(len(delays) == len(text));
	$DynamicTextBox.visible = false;
	$Fader.lighten(INITIAL_FADE_IN_DELAY);
	$Foreground.texture = frames[0];
	cur_total_wait_time = delays[0];

	# Add check
	if cur_frame_index == len(frames):
		should_end_cutscene = true;
		return;
		
	$Background.texture = frames[cur_frame_index + 1];


func should_use_delays():
	return delays[cur_frame_index] != 0;

func _process(delta: float) -> void:
	if should_use_delays():
		cur_wait_time += delta;
		
		if cur_wait_time >= cur_total_wait_time:
			if should_end_cutscene:
				if not is_ending:
					$Fader.darken(2);
					await get_tree().create_timer(2).timeout.connect(func (): load_next_scene_if_finished("res://scene/main_game.tscn"));
					is_ending = true;
				return;
				
			$Foreground.modulate.a -= delta / FADE_TIME_BETWEEN_FRAMES;
			if $Foreground.modulate.a <= 0:
				$Foreground.texture = $Background.texture;
				$Foreground.modulate.a = 1;
				cur_frame_index += 1;
				cur_wait_time = 0;
				cur_total_wait_time = delays[cur_frame_index];

				# Add check
				if cur_frame_index == len(frames) - 1:
					should_end_cutscene = true;
					return;
					
				$Background.texture = frames[cur_frame_index + 1];
	else:
		show_text_box();
		if need_to_add_text:
			$DynamicTextBox.display_new_text(text[cur_frame_index]);
			need_to_add_text = false;
			
		if Input.is_action_just_pressed("Down"):
			$DynamicTextBox.display_next_line();
			if $DynamicTextBox.is_finished():
				cur_frame_index += 1;
				need_to_add_text = true;

func hide_text_box():
	$DynamicTextBox.visible = false;

func show_text_box():
	$DynamicTextBox.visible = true;

func wait(secs : float):
	await get_tree().create_timer(secs).timeout;

func load_next_scene_if_finished(next_scene_location : String):
	get_tree().change_scene_to_file(next_scene_location);
