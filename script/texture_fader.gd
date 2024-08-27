extends TextureRect


@export var texture_to_show : Texture2D;


enum FADE_DIRECTION { DARKEN, LIGHTEN, OFF }
var fade_mode : FADE_DIRECTION = FADE_DIRECTION.OFF;

var cur_pause_seconds = 0;
var pause_seconds = 0;
var cur_fade_seconds = 0;
var goal_fade_seconds = 0;
var fade_speed = 100;


func _ready() -> void:
	visible = true;


func _process(delta: float) -> void:
	if fade_mode == FADE_DIRECTION.OFF:
		return;
	
	if cur_pause_seconds < pause_seconds:
		cur_pause_seconds += delta;
		return;
	
	if cur_fade_seconds >= goal_fade_seconds:
		fade_mode = FADE_DIRECTION.OFF;
		return;
	
	cur_fade_seconds += delta;
	
	if fade_mode == FADE_DIRECTION.DARKEN:
		modulate.a = clampf(cur_fade_seconds / goal_fade_seconds, 0, 1);
	else:
		modulate.a = clampf(1 - cur_fade_seconds / goal_fade_seconds, 0, 1);
	

func darken(seconds_to_fade : float, seconds_to_pause : float):
	cur_pause_seconds = 0;
	pause_seconds = seconds_to_pause;
	cur_fade_seconds = 0;
	goal_fade_seconds = seconds_to_fade;
	fade_mode = FADE_DIRECTION.DARKEN;
	
func lighten(seconds_to_fade : float, seconds_to_pause : float):
	cur_pause_seconds = 0;
	pause_seconds = seconds_to_pause;
	cur_fade_seconds = 0;
	goal_fade_seconds = seconds_to_fade;
	fade_mode = FADE_DIRECTION.LIGHTEN;
