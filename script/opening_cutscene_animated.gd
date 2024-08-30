extends Control

const INITIAL_FADE_IN_DELAY := 3;
#const FADE_TIME_BETWEEN_FRAMES := 0.5;
var cur_wait_time : float = 0;
var foreground_frame_index : int = 0;

@export var scene_to_load_upon_completion : String;

var cur_total_wait_time : float = 0;
var cur_fade_time : float = 0;

# Full of arrays of strings
var text : Array[Array] = [
	["[i]Finally, you've dragged yourself out of your hovel and into the wide world of business.[/i]", "[i]That new office building located conveniently near your apartment has been aggressively advertising for a while now, so you figured throwing your resume at them might make them realize you're useless and finally stop bothering you.[/i]", "[i]To your surprise, they called you back for an interview...[/i]"],
	["m:Hmm. Well, I suppose the fact that you even showed up at all is commendable."],
	["m:I'm sure we can find [b]something[/b] for you to do."],
	["m:Welcome to Inventory Inc."]
	];

var is_ending := false;
var scene_index : int = 0; 

var should_display_text := false;
func play_at_index(index : int):
	var scenes = $Scenes.get_children();
	
	for i in range(len(scenes)):
		if i == index:
			scenes[i].visible = true;
			scenes[i].play();
			scenes[i].animation_finished.connect(func(): 
				should_display_text = true;
				);
		else:
			scenes[i].visible = false;


func _ready() -> void:
	$BGM.fade_in(2);
	$DynamicTextBox.visible = false;
	$Fader.lighten(INITIAL_FADE_IN_DELAY);
	play_at_index(0);


func should_end_cutscene():
	if scene_index > len($Scenes.get_children()) - 1:
		return true;

func _process(delta: float) -> void:
	if is_ending:
		return;
		
	if should_end_cutscene():
		if not is_ending:
			$Fader.darken(2);
			$BGM.fade_out(2);
			Utility.load_scene(2, scene_to_load_upon_completion);
			is_ending = true;
		return;
	
	if should_display_text:
		should_display_text = false;
		$DynamicTextBox.display_new_text(text[scene_index]);
	
	if Input.is_action_just_pressed("accept"):
		$DynamicTextBox.display_next_line();	
		
		if $DynamicTextBox.is_finished():
			scene_index += 1;
			if should_end_cutscene():
				if not is_ending:
					$Fader.darken(2);
					$BGM.fade_out(2);
					Utility.load_scene(2, scene_to_load_upon_completion);
					is_ending = true;
				return;
			else:
				play_at_index(scene_index);


func hide_text_box():
	$DynamicTextBox.visible = false;

func show_text_box():
	$DynamicTextBox.visible = true;
