extends Node2D

@export var pass_texture : Texture2D;
@export var fail_texture : Texture2D;
@export var transparent_texture : Texture2D;


# All should be in WASD order. For example, for PS: Triangle, Square, Cross, Circle
@export var wasd_textures : Array[Texture2D];
@export var arrowkey_textures : Array[Texture2D];
@export var xbox_textures : Array[Texture2D];
@export var ps_textures : Array[Texture2D];
@export var nintendo_textures : Array[Texture2D];



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

func set_next_key_texture(next_key : Enums.NEXT_KEY):
	if next_key == Enums.NEXT_KEY.UP:
		$NextKeyIndicator.texture = get_cur_texture_set()[0];
	elif next_key == Enums.NEXT_KEY.LEFT:
		$NextKeyIndicator.texture = get_cur_texture_set()[1];
	elif next_key == Enums.NEXT_KEY.DOWN:
		$NextKeyIndicator.texture = get_cur_texture_set()[2];
	elif next_key == Enums.NEXT_KEY.RIGHT:
		$NextKeyIndicator.texture = get_cur_texture_set()[3];	
		

func get_cur_texture_set() -> Array[Texture2D]:
	if control_icons == Enums.BUTTON_MODE.WASD:
		return wasd_textures;
	elif control_icons == Enums.BUTTON_MODE.ARROW:
		return arrowkey_textures;
	elif control_icons == Enums.BUTTON_MODE.PS:
		return ps_textures;
	elif control_icons == Enums.BUTTON_MODE.XBOX:
		return xbox_textures;
	elif control_icons == Enums.BUTTON_MODE.NINTENDO:
		return nintendo_textures;
	else:
		print("Holy moly, the controller glyph setting is busted!");
		return wasd_textures;
