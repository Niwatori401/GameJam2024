extends Node


# All should be in WASD Action Cancel order. For example, for PS: Triangle, Square, Cross, Circle
var wasd_textures : Array[Texture2D] = [
	preload("res://asset/NextKeyIndicator/ControlGlyphs/WASD/w.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/WASD/A.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/WASD/S.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/WASD/D.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/WASD/enter.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/WASD/esc.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/WASD/navigation.png")
];
var arrowkey_textures : Array[Texture2D] = [
	preload("res://asset/NextKeyIndicator/ControlGlyphs/Arrow/Up.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/Arrow/left.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/Arrow/down.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/Arrow/right.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/Arrow/enter.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/Arrow/esc.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/Arrow/navigation.png")
];
var xbox_textures : Array[Texture2D] = [
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/y.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/x.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/a.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/b.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/a.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/b.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/dpad.png")
];
var ps_textures : Array[Texture2D] = [
	preload("res://asset/NextKeyIndicator/ControlGlyphs/PS/triangle.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/PS/square.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/PS/cross.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/PS/circle.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/PS/cross.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/PS/circle.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/PS/dpad.png")
];
var nintendo_textures : Array[Texture2D] = [
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/x.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/y.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/b.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/a.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/b.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/a.png"),
	preload("res://asset/NextKeyIndicator/ControlGlyphs/NintendoXbox/dpad.png")
];

var iconSet : Enums.BUTTON_MODE = Enums.BUTTON_MODE.ARROW;

func set_key_set(icon_set : Enums.BUTTON_MODE):
	iconSet = icon_set;

func get_texture_set() -> Array[Texture2D]:
	if iconSet == Enums.BUTTON_MODE.WASD:
		return ButtonGraphics.wasd_textures;
	elif iconSet == Enums.BUTTON_MODE.ARROW:
		return ButtonGraphics.arrowkey_textures;
	elif iconSet == Enums.BUTTON_MODE.PS:
		return ButtonGraphics.ps_textures;
	elif iconSet == Enums.BUTTON_MODE.XBOX:
		return ButtonGraphics.xbox_textures;
	elif iconSet == Enums.BUTTON_MODE.NINTENDO:
		return ButtonGraphics.nintendo_textures;
	else:
		print("Holy moly, the controller glyph setting is busted!");
		return ButtonGraphics.wasd_textures;
