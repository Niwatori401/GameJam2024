extends Node2D

@export var pass_texture : Texture2D;
@export var fail_texture : Texture2D;
@export var transparent_texture : Texture2D;


var config = ConfigFile.new();
var control_icons : Enums.BUTTON_MODE;

func _ready() -> void:
	var status = config.load("user://config.cfg");
	if status != OK:
		printerr("Failed to load config in next_key_indicator");
		
	control_icons = config.get_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_CONTROL_SCEME, Enums.BUTTON_MODE.WASD);


func set_to_pass_icon():
	$SuccessIndicator.texture = pass_texture;

func set_to_fail_icon():
	$SuccessIndicator.texture = fail_texture;
	
func set_to_none_icon():
	$SuccessIndicator.texture = transparent_texture;


func stop_progress_circle():
	$NextKeyGroup/ProgressCircle.stop_circle();

func start_progress_circle():
	$NextKeyGroup/ProgressCircle.start_circle(1);

func set_circle_progress(percent : float):
	$NextKeyGroup/ProgressCircle.set_circle_full_percent(percent);

func set_next_key_texture(next_key : Array[Enums.KEY_DIRECTION]):
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
		node.get_children()[i].texture = ButtonGraphics.get_texture_set()[next_key[i]];

		
