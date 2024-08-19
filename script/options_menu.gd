class_name OptionsMenu extends Control


var config = ConfigFile.new();

var video_resolutions = {
	"1920 x 1080":Vector2i(1920, 1080),
	"1366 x 768":Vector2i(1366, 768),
	"1280 x 720":Vector2i(1280, 720),
	"640 x 360":Vector2i(640, 360)
}

var glyph_options = {
	"WASD":Enums.BUTTON_MODE.WASD,
	"Arrow Keys":Enums.BUTTON_MODE.ARROW,
	"XBox":Enums.BUTTON_MODE.XBOX,
	"PlayStation":Enums.BUTTON_MODE.PS,
	"Nintendo":Enums.BUTTON_MODE.NINTENDO
}

func _ready() -> void:
	config.load("user://config.cfg");
	initialize_video_dropdown();
	initialize_glyph_dropdown();
	


func _on_full_screen_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().get_root().set_mode(Window.MODE_FULLSCREEN);
	else:
		get_tree().get_root().set_mode(Window.MODE_WINDOWED);


func _on_video_resolution_dropdown_item_selected(index: int) -> void:
	var resolution = video_resolutions[$Options/VideoSettings/VideoResolutionDropdown.get_item_text(index)]
	get_window().size = resolution;


func _on_control_glyph_dropdown_item_selected(index: int) -> void:
	var display_glyphs = glyph_options[$Options/ControlGlyphs/ControlGlyphDropdown.get_item_text(index)];
	config.set_value("options", "control_scheme", display_glyphs);
	config.save("user://config.cfg")

func _on_volume_slider_value_changed(value: float) -> void:
	if (value == 0):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true);
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false);
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerp(-30, 15, value / 100));
	
func _on_back_button_button_up() -> void:
	const DARKEN_SECONDS = 1;
	$Fader.darken(DARKEN_SECONDS);
	await get_tree().create_timer(DARKEN_SECONDS).timeout.connect(func (): 
		visible = false;
		SignalBus.back_button_pressed.emit();
		);

func initialize_glyph_dropdown():
	$Options/ControlGlyphs/ControlGlyphDropdown.clear();
	for glyph in glyph_options:
		$Options/ControlGlyphs/ControlGlyphDropdown.add_item(glyph);

func initialize_video_dropdown():
	$Options/VideoSettings/VideoResolutionDropdown.clear();
	for resolution in video_resolutions:
		$Options/VideoSettings/VideoResolutionDropdown.add_item(resolution);

func show_options():
	$Fader.lighten(1);
	visible = true;
