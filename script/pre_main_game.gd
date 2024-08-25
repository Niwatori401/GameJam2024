extends Node2D


func _ready() -> void:
	$BGM.fade_in(2);

var paper_is_up := false;
func _on_clip_board_button_down() -> void:
	if paper_is_up:
		$Control/PaperMessage.start_move_down();
	else:
		$Control/PaperMessage.start_move_up();
	
	paper_is_up = !paper_is_up;
