extends Node2D

@export var pass_texture : Texture2D;
@export var fail_texture : Texture2D;
@export var transparent_texture : Texture2D;


var config = ConfigFile.new();
var control_icons : Enums.BUTTON_MODE;

func _ready() -> void:
	config.load("user://config.cfg");
	control_icons = config.get_value("options", "control_scheme", Enums.BUTTON_MODE.WASD);
	# start_progress_circle();


func _process(delta: float) -> void:
	pass

func set_to_pass_icon():
	$SuccessIndicator.texture = pass_texture;

func set_to_fail_icon():
	$SuccessIndicator.texture = fail_texture;
	
func set_to_none_icon():
	$SuccessIndicator.texture = transparent_texture;


func stop_progress_circle():
	$ProgressCircle.stop_circle();

func start_progress_circle():
	$ProgressCircle.start_circle(1);

func set_circle_progress(percent : float):
	$ProgressCircle.set_circle_full_percent(percent);

func set_next_key_texture(next_key : Array[Enums.NEXT_KEY]):
	var node : Node2D;
	
	$NextKeyGroup/Single.visible = len(next_key) == 1;
	$NextKeyGroup/Double.visible = len(next_key) == 2;
	$NextKeyGroup/Triple.visible = len(next_key) == 3;
	
	if len(next_key) == 1:
		node = $NextKeyGroup/Single;
	elif len(next_key) == 2:
		node = $NextKeyGroup/Double;
	elif len(next_key) == 3:
		node = $NextKeyGroup/Triple;
	else:
		print("Invalid key count in set_next_key_texture");
		return;
	
	
	for i in range(len(next_key)):
		node.get_children()[i].texture = ButtonGraphics.get_texture_set(control_icons)[next_key[i]];

		
