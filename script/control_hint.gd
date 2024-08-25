extends Control

@export var controlFunctionText : String = "- Continue";
@export var buttonType : Enums.KEY_DIRECTION = Enums.KEY_DIRECTION.UP;

func _ready() -> void:
	$HBoxContainer/Label.text = controlFunctionText;
	$HBoxContainer/GlyphTexture.texture = ButtonGraphics.get_texture_set()[buttonType];
	SignalBus.glyphs_updated.connect(update_glyphs);

func update_glyphs() -> void:
	$HBoxContainer/GlyphTexture.texture = ButtonGraphics.get_texture_set()[buttonType];
