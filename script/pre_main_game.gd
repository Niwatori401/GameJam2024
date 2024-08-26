extends Node2D
var paper_viewed := false;
@export var is_beginning_of_day := true;

func _ready() -> void:
	$NonGameOffice/Fader.lighten(2);
	$BGM.fade_in(2);
	$NonGameOffice/ClipBoard.grab_focus();
	$NonGameOffice/LunchPail.visible = not is_beginning_of_day;

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		$NonGameOffice/PaperMessage.start_move_down();
		paper_viewed = true;
		paper_is_up = false;

var is_loading := false;
var paper_is_up := false;
func _on_clip_board_button_down() -> void:
	if paper_is_up or is_loading:
		return;
		
	if not paper_viewed:
		$NonGameOffice/PaperMessage.start_move_up();
		paper_is_up = true;
		return;
	
	is_loading = true;
	$NonGameOffice/Fader.darken(3);
	Utility.load_scene(2.5, Globals.SCENE_MAIN_GAME);

func _on_lunch_pail_button_down() -> void:
	Utility.load_scene(3, Globals.SCENE_BREAK_ROOM);
	$NonGameOffice/Fader.darken(2.5);
