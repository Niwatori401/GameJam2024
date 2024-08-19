extends Control


# 0 for instant
@export var letters_per_second : float = 240;
var time_since_last_character : float = 0;

var text_to_display : Array = [];
var text_to_display_index : int = 0;

var current_display_letter_index : int = 0;

var open_percent : float = 1;
var open_duration_seconds : float = 0.2;
var open_mode : Enums.OPEN_MODE = Enums.OPEN_MODE.NONE;

var continue_progress : float = 0;


func _process(delta: float) -> void:

	if do_box_transitions(delta):
		return;
	
		# Last line of text finished
	if is_finished():
		start_close_box();
		return;
	
	
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
		for i in range(floor(time_since_last_character / (1 / letters_per_second))):
			$SpeechText.text += text_to_display[text_to_display_index][current_display_letter_index]
			current_display_letter_index += 1;
			if done_with_last_letter():
				break;
				
		time_since_last_character = 0;

func start_close_box():
	open_mode = Enums.OPEN_MODE.CLOSE;

func start_open_box():
	open_mode = Enums.OPEN_MODE.OPEN;

func display_next_line():
	current_display_letter_index = 0;
	text_to_display_index += 1;
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

func display_new_text(new_text: Array):
	text_to_display = new_text;
	text_to_display_index = 0;
	current_display_letter_index = 0;
	$SpeechText.text = "";
	start_open_box();

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
				open_mode = Enums.OPEN_MODE.NONE;
				return true;
			
			scale.x -= open_change;
		return true;
	return false;
	
