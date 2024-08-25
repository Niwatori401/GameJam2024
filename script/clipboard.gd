extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RolledPaperBack.visible = false;

var first_paper := true;
func cycle_clipboard_animation():
	if first_paper:
		first_paper = false;
		$ClipboardAnimation.play("flip_1");
	else:
		$RolledPaperBack.visible = true;
		$ClipboardAnimation.play("flip_2")
		
