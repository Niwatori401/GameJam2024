extends Control


# 0 for instant
@export var letters_per_second : float = 240;
var time_since_last_character : float = 0;

var text_to_display : Array[String] = [];
var text_to_display_index : int = 0;

var current_display_letter_index : int = 0;

var open_percent : float = 1;
var open_duration_seconds : float = 0.2;
var open_mode : Enums.OPEN_MODE = Enums.OPEN_MODE.NONE;

func _ready():
	display_new_text(["Velit sit ipsum et dolore tempore vero est. Qui in nihil eaque omnis hic maxime quo. Itaque qui ipsam porro.", "In consequuntur vitae odit non repellendus quas numquam in. Non incidunt est nesciunt et. Deserunt a qui cumque.", "eggs"]);

func _process(delta: float) -> void:

	if Input.is_action_just_pressed("debug_2"):
		display_new_text(["Velit sit ipsum et dolore tempore vero est. Qui in nihil eaque omnis hic maxime quo. Itaque qui ipsam porro.", "In consequuntur vitae odit non repellendus quas numquam in. Non incidunt est nesciunt et. Deserunt a qui cumque.", "eggs"]);

	if Input.is_action_just_pressed("debug_1"):
		display_next_line();
	
	if do_box_transitions(delta):
		return;
	
	# Last line of text finished
	if text_to_display_index > len(text_to_display) - 1:
		start_close_box();
		return;
	
	if letters_per_second == 0:
		$SpeechText.text = text_to_display[text_to_display_index];
		current_display_letter_index = len(text_to_display[text_to_display_index]) - 1;
		return;
		
	# End of current line
	if current_display_letter_index > len(text_to_display[text_to_display_index]) - 1:
		return;
	
	time_since_last_character += delta;
	
	if time_since_last_character >= (1 / letters_per_second):
		for i in range(floor(time_since_last_character / (1 / letters_per_second))):
			$SpeechText.text += text_to_display[text_to_display_index][current_display_letter_index]
			current_display_letter_index += 1;
			if current_display_letter_index > len(text_to_display[text_to_display_index]) - 1:
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

func display_new_text(new_text: Array[String]):
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
	
