extends Node2D


# All should be in WASD order. For example, for PS: Triangle, Square, X, Circle
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
	
func _process(delta: float) -> void:
	pass


func set_next_key(next_key : Enums.NEXT_KEY):
	pass
