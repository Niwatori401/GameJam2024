extends AudioStreamPlayer

@export var low_db : float = -20;
@export var high_db : float = 0;

var cur_fade_time : float = 0;
var total_time_to_fade : float;

enum FADE_MODE { OUT, IN, NONE }
var fade_mode : FADE_MODE = FADE_MODE.NONE;


func _ready() -> void:
	volume_db = low_db;


func _process(delta: float) -> void:
	if fade_mode == FADE_MODE.NONE:
		return;
	
	cur_fade_time += delta;
	var fade_percent : float = cur_fade_time / total_time_to_fade;
	
	if fade_mode == FADE_MODE.IN:
		if fade_percent >= 1:
			volume_db = high_db;
			fade_mode = FADE_MODE.NONE;
			return;
			
		var target_db = low_db + (high_db - low_db) * (fade_percent);
		volume_db = target_db;
	# FADE_MODE.OUT
	else:
		if fade_percent >= 1:
			volume_db = low_db;
			fade_mode = FADE_MODE.NONE;
			return;
			
		var target_db = high_db + (low_db - high_db) * (fade_percent);
		volume_db = target_db;


func fade_in(seconds_to_fade : float):
	fade_mode = FADE_MODE.IN;
	cur_fade_time = 0;
	total_time_to_fade = seconds_to_fade;
	
func fade_out(seconds_to_fade : float):
	fade_mode = FADE_MODE.OUT;
	cur_fade_time = 0;
	total_time_to_fade = seconds_to_fade;
