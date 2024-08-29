extends Control

var tag_to_name_string = {
	"m:":"[color=#532223][b][i]Manager[/i][/b][/color]/n",
	"h:":"[color=#000000][b][i]Human Resources[/i][/b][/color]/n",
	"p:":"[color=#51724c][b][i]You[/i][/b][/color]/n",
	"c:":"[color=#c18332][b][i]The Client[/i][/b][/color]/n",
	"s:":"[color=#353535][b][i]Shady Sam[/i][/b][/color]/n"
}

var tag_to_voice = {
	"m:": [
		preload("res://asset/sound/voiceBits/manager/voice_bit_management_1.ogg"),
		preload("res://asset/sound/voiceBits/manager/voice_bit_management_2.ogg"),
	],
	"h:": [
		preload("res://asset/sound/voiceBits/hr/voice_bit_hr1.ogg"),
		preload("res://asset/sound/voiceBits/hr/voice_bit_hr2.ogg"),
	],
	"p:": null,
	"c:": [
		preload("res://asset/sound/voiceBits/client/voice_bit_client_1.ogg"),
		preload("res://asset/sound/voiceBits/client/voice_bit_client_2.ogg"),
		preload("res://asset/sound/voiceBits/client/voice_bit_client_3.ogg"),
	],
	"s:": [
		preload("res://asset/sound/voiceBits/shady_sam/voice_bit_shady_sam.ogg")
		]
}

# 0 for instant
@export var letters_per_second : float = 240;

var time_since_last_character : float = 0;

var text_to_display : Array = [];
var text_to_display_index : int = 0;

var client_cam_state_for_text : Array[Enums.CLIENT_CAM_STATE] = [];

var current_display_letter_index : int = 0;

var open_percent : float = 1;
var open_duration_seconds : float = 0.2;
var open_mode : Enums.OPEN_MODE = Enums.OPEN_MODE.NONE;

var continue_progress : float = 0;

var pause_symbol : String = "`"
var time_to_wait_between_pause = 0.5;
var cur_pause_wait_time : float= 0;

func _ready() -> void:
	scale.x = 0;
	visible = false;
	open_mode = Enums.OPEN_MODE.NONE;

func _process(delta: float) -> void:

	if do_box_transitions(delta):
		return;
	
		# Last line of text finished
	if is_finished():
		start_close_box();
		return;
	else:
		pass;
	
	
	if current_display_letter_index == len(text_to_display[text_to_display_index]):
		show_continue_icon();
		oscillate_continue_icon(delta);
	else:
		hide_continue_icon();
	

	if letters_per_second == 0:
		$SpeechText.text = text_to_display[text_to_display_index];
		current_display_letter_index = len(text_to_display[text_to_display_index]);
		return;
		
	if done_with_last_letter():
		return;
	
	time_since_last_character += delta;
	
	if time_since_last_character >= (1 / letters_per_second):
		var text_to_add : String = "";
		while not done_with_last_letter() and text_to_display[text_to_display_index][current_display_letter_index] == "[":
			while not done_with_last_letter() and text_to_display[text_to_display_index][current_display_letter_index] != "]":
				text_to_add += text_to_display[text_to_display_index][current_display_letter_index];
				current_display_letter_index += 1;
				if done_with_last_letter():
					$SpeechText.text += text_to_add;
					time_since_last_character = 0;
					return;
			
			text_to_add += "]";
			current_display_letter_index += 1;
		
		if text_to_add != "":
			$SpeechText.text += text_to_add;
		
		if done_with_last_letter():
			time_since_last_character = 0;
			return;
		
		if text_to_display[text_to_display_index][current_display_letter_index] == "/":
			if text_to_display[text_to_display_index][current_display_letter_index + 1] == "n":
				$SpeechText.text += "\n";
				current_display_letter_index += 2;
		
		
		for i in range(floor(time_since_last_character / (1 / letters_per_second))):
			var cur_char = text_to_display[text_to_display_index][current_display_letter_index];
			if cur_char == "[" or cur_char == "]":
				break;
			
			if cur_char == pause_symbol:
				cur_pause_wait_time += delta;
				if cur_pause_wait_time >= time_to_wait_between_pause:
					time_since_last_character = 0;
					cur_pause_wait_time = 0;
					current_display_letter_index += 1;
			
				return;
				
			$SpeechText.text += cur_char;
			current_display_letter_index += 1;
			if done_with_last_letter():
				break;
				
		time_since_last_character = 0;

func start_close_box():
	open_mode = Enums.OPEN_MODE.CLOSE;

func start_open_box():
	visible = true;
	open_mode = Enums.OPEN_MODE.OPEN;

func display_next_line():
	current_display_letter_index = 0;
	text_to_display_index += 1;
	if should_use_cam_state() and text_to_display_index < len(client_cam_state_for_text):
		SignalBus.client_cam_state_changed.emit(client_cam_state_for_text[text_to_display_index]);
	$SpeechText.text = "";


func done_with_last_letter():
	return current_display_letter_index > len(text_to_display[text_to_display_index]) - 1

func is_finished():
	return text_to_display_index > len(text_to_display) - 1;

func hide_continue_icon():
	$ContinueIcon.visible = false;
	continue_progress = 0;
	
func show_continue_icon():
	$ContinueIcon.visible = true;
	
func oscillate_continue_icon(delta):
	continue_progress += delta;
	$ContinueIcon.modulate.a = abs(sin(continue_progress));


func should_use_cam_state() -> bool:
	return len(client_cam_state_for_text) != 0;


func display_new_text(new_text: Array, client_cam_state : Array[Enums.CLIENT_CAM_STATE] = []):
	client_cam_state_for_text = client_cam_state;
	if len(client_cam_state_for_text) != 0 and len(client_cam_state_for_text) != len(new_text):
		printerr("Cam state was not set successfully!");
		client_cam_state_for_text = [];
		
	text_to_display = new_text;
	text_to_display_index = 0;
	current_display_letter_index = 0;
	$SpeechText.text = "";
	replace_tags_with_name_strings();
	start_open_box();
	if should_use_cam_state():
		SignalBus.client_cam_state_changed.emit(client_cam_state_for_text[0]);

func replace_single_line(tag : String, line_index : int) -> void:
	if text_to_display[line_index].contains(tag):
			text_to_display[line_index] = text_to_display[line_index].replace(tag, tag_to_name_string[tag]);

func replace_tags_with_name_strings():
	for line_index in range(len(text_to_display)):
		replace_single_line("m:", line_index);
		replace_single_line("h:", line_index);
		replace_single_line("p:", line_index);
		replace_single_line("c:", line_index);
		replace_single_line("s:", line_index);

# returns true if currently transitioning
func do_box_transitions(delta) -> bool:
	if open_mode != Enums.OPEN_MODE.NONE:
		var open_change : float = delta / open_duration_seconds;
		# OPEN
		if open_mode == Enums.OPEN_MODE.OPEN:
			if open_change > 1 - scale.x:
				scale.x = 1;
				open_mode = Enums.OPEN_MODE.NONE;
				return true;
			
			scale.x += open_change;
		# CLOSE mode
		else:
			if open_change > scale.x:
				scale.x = 0;
				visible = false;
				open_mode = Enums.OPEN_MODE.NONE;
				return true;
			
			scale.x -= open_change;
		return true;
	return false;
	
