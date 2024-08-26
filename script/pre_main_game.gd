extends Node2D


func _ready() -> void:
	$NonGameOffice/Fader.lighten(2);
	$BGM.fade_in(2);
	$NonGameOffice/ClipBoard.grab_focus();

var paper_is_up := false;
func _on_clip_board_button_down() -> void:
	if paper_is_up:
		$NonGameOffice/PaperMessage.start_move_down();
	else:
		$NonGameOffice/PaperMessage.start_move_up();
	
	paper_is_up = !paper_is_up;


func _on_lunch_pail_button_down() -> void:
	Utility.load_scene(3, Globals.SCENE_BREAK_ROOM);
	$NonGameOffice/Fader.darken(2.5);
