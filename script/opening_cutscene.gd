extends Control

const INITIAL_FADE_IN_DELAY := 3;
const FADE_TIME_BETWEEN_FRAMES := 0.5;
var cur_wait_time : float = 0;
var cur_frame_index : int = 0;

var cur_total_wait_time : float = 0;
var cur_fade_time : float = 0;

@export var frames : Array[Texture2D] = [];
@export var delays : Array[float] = [];

var should_end_cutscene := false;
var is_ending := false;

func _ready() -> void:
	assert(len(delays) == len(frames));
	$Fader.lighten(INITIAL_FADE_IN_DELAY);
	$Foreground.texture = frames[0];
	cur_total_wait_time = delays[0];

	# Add check
	if cur_frame_index == len(frames):
		should_end_cutscene = true;
		return;
		
	$Background.texture = frames[cur_frame_index + 1];

func _process(delta: float) -> void:
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
			

func wait(secs : float):
	await get_tree().create_timer(secs).timeout;

func load_next_scene_if_finished(next_scene_location : String):
	get_tree().change_scene_to_file(next_scene_location);
