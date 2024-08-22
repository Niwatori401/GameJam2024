extends Control


@export var animation_duration_secs : float = 1;
var secs_per_frame : float;
var shady_sam_opened : bool = false;

func _ready():
	$Fader.lighten(0.5);
	secs_per_frame = animation_duration_secs / len($ShadySamAnimation.get_children());

func _process(delta: float) -> void:
	if not $ShadySamButton.has_focus() and shady_sam_opened:
		reverse_animation();


func _on_shady_sam_button_button_down() -> void:
	play_animation();
	
	
func reverse_animation():
	shady_sam_opened = false;
	get_tree().create_timer(1 * secs_per_frame).timeout.connect(func (): 
		$ShadySamAnimation/ShadySamAnimation2.visible = false;
		$ShadySamAnimation/ShadySamAnimation1.visible = true;
		);
	get_tree().create_timer(2 * secs_per_frame).timeout.connect(func (): $ShadySamAnimation/ShadySamAnimation1.visible = false);


func play_animation():
	get_tree().create_timer(1 * secs_per_frame).timeout.connect(func (): $ShadySamAnimation/ShadySamAnimation1.visible = true);
	get_tree().create_timer(2 * secs_per_frame).timeout.connect(func (): 
		$ShadySamAnimation/ShadySamAnimation1.visible = false
		$ShadySamAnimation/ShadySamAnimation2.visible = true
		shady_sam_opened = true);


func _on_back_button_button_down() -> void:
	$Fader.darken(0.5);
	Utility.load_scene(0.5, Globals.SCENE_BREAK_ROOM);
