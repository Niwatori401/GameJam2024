class_name OptionsMenu extends Control


const VOLUME_MIN_DB : float = -40;
const VOLUME_MAX_DB : float = 10;

const MAX_TEXT_SPEED : float = 240;
const MIN_TEXT_SPEED : float = 60;

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
	initialize_video_dropdown();
	initialize_glyph_dropdown();
	initialize_volume_slider();
	load_and_init_config_values();
	$Options/DeleteSaveButton.disabled = false;


func _on_full_screen_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().get_root().set_mode(Window.MODE_FULLSCREEN);
	else:
		get_tree().get_root().set_mode(Window.MODE_WINDOWED);
		
	Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_FULLSCREEN, toggled_on);
	Inventory.get_config().save(Globals.USER_CONFIG_FILE);

func _on_video_resolution_dropdown_item_selected(index: int) -> void:
	var resolution_string = $Options/VideoSettings/VideoResolutionDropdown.get_item_text(index);
	var resolution = video_resolutions[resolution_string];
	get_window().size = resolution;
	Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_RESOLUTION, resolution_string);
	Inventory.get_config().save(Globals.USER_CONFIG_FILE);

func _on_control_glyph_dropdown_item_selected(index: int) -> void:
	var display_glyphs = glyph_options[$Options/ControlGlyphs/ControlGlyphDropdown.get_item_text(index)];
	Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_CONTROL_SCEME, display_glyphs);
	Inventory.get_config().save(Globals.USER_CONFIG_FILE);
	ButtonGraphics.set_key_set(display_glyphs);
	SignalBus.glyphs_updated.emit();


func _on_volume_slider_value_changed(value: float) -> void:
	set_volume(value);
	update_volume_text();
	Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_VOLUME, value);
	Inventory.get_config().save(Globals.USER_CONFIG_FILE);
	
func _on_back_button_button_up() -> void:
	const DARKEN_SECONDS = 1;
	$Fader.darken(DARKEN_SECONDS);
	get_tree().create_timer(DARKEN_SECONDS).timeout.connect(func (): 
		visible = false;
		SignalBus.back_button_pressed.emit();
		);

# not in decimal percent, but 0-100
func set_volume(value : float):
	if (value == 0):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true);
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false);
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerp(VOLUME_MIN_DB, VOLUME_MAX_DB, value / 100));

func initialize_glyph_dropdown():
	$Options/ControlGlyphs/ControlGlyphDropdown.clear();
	for glyph in glyph_options:
		$Options/ControlGlyphs/ControlGlyphDropdown.add_item(glyph);

func initialize_video_dropdown():
	$Options/VideoSettings/VideoResolutionDropdown.clear();
	for resolution in video_resolutions:
		$Options/VideoSettings/VideoResolutionDropdown.add_item(resolution);

func initialize_volume_slider():
	var bus_index = AudioServer.get_bus_index("Music");
	var current_db = AudioServer.get_bus_volume_db(bus_index);
	var percent_on_slider = (current_db - VOLUME_MIN_DB) / (VOLUME_MAX_DB - VOLUME_MIN_DB)
	$Options/AudioSettings/VolumeSlider.set_value_no_signal(percent_on_slider * 100);
	update_volume_text();
	

func update_volume_text() -> void:
	$Options/AudioSettings/VolumeLabel.text = "[center]Volume[/center] (%d%%)" % [round($Options/AudioSettings/VolumeSlider.value)]
	
func update_text_speed_slider(text_speed : float) -> void:
	if text_speed == -1:
		$Options/TextSpeed/TextSpeedSlider.value = MAX_TEXT_SPEED;
	else:
		$Options/TextSpeed/TextSpeedSlider.value = text_speed;
	
	if $Options/TextSpeed/TextSpeedSlider.value == MAX_TEXT_SPEED:
		$Options/TextSpeed/TextSpeedLabel.text = "[center]Text Speed (Instant)[/center]";
	else:
		$Options/TextSpeed/TextSpeedLabel.text = "[center]Text Speed (%d letters/second)[/center]" % [text_speed];
	
func show_options():
	$Fader.lighten(1);
	visible = true;
	$Options/ControlGlyphs/ControlGlyphDropdown.grab_focus();


func load_and_init_config_values():
	var control_glyphs = Inventory.get_config().get_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_CONTROL_SCEME, Enums.BUTTON_MODE.ARROW);
	var text_speed = Inventory.get_config().get_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_TEXT_SPEED, MIN_TEXT_SPEED);
	var resolution = Inventory.get_config().get_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_RESOLUTION, "1920 x 1080");
	var is_fullscreen = Inventory.get_config().get_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_FULLSCREEN, true);
	var volume = Inventory.get_config().get_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_VOLUME, 50);
	var has_voiced_dialog = Inventory.get_config().get_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_VOICED_DIALOG, true);

	# Control Glyphs
	for glyph_index in range(len(glyph_options)):
		if control_glyphs == glyph_options.values()[glyph_index]:
			$Options/ControlGlyphs/ControlGlyphDropdown.select(glyph_index);
			break;
	
	ButtonGraphics.set_key_set(control_glyphs);
	if not Inventory.get_config().has_section_key(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_CONTROL_SCEME):
		Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_CONTROL_SCEME, control_glyphs);
	
	
	
	# Volume
	set_volume(volume);
	update_volume_text();
	# Setting volume automatically saves it
	$Options/AudioSettings/VolumeSlider.set_value(volume);

	# Resolution
	get_window().call_deferred("set_size", video_resolutions[resolution]);
	for res_index in range(len(video_resolutions)):
		if video_resolutions.keys()[res_index] == resolution:
			$Options/VideoSettings/VideoResolutionDropdown.select(res_index);
			break;
			
	if not Inventory.get_config().has_section_key(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_RESOLUTION):
		Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_RESOLUTION, resolution);
		
	
	
	# Voiced Dialog
	# is saved by setting the value like this
	$Options/AudioSettings/DialogNoisesCheckbox.button_pressed = has_voiced_dialog;
	
	# Fullscreen
	# is saved by setting the value like this
	$Options/FullScreenCheckbox.button_pressed = is_fullscreen;
	if is_fullscreen:
		get_tree().get_root().set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN);
	else:
		get_tree().get_root().set_mode(Window.MODE_WINDOWED);
	
	# Text speed
	$Options/TextSpeed/TextSpeedSlider.set_value(text_speed);
	update_text_speed_slider(text_speed);
	if not Inventory.get_config().has_section_key(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_TEXT_SPEED):
		Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_TEXT_SPEED, text_speed);
		
	
	# Save changed made for defaults
	Inventory.get_config().save(Globals.USER_CONFIG_FILE);


func _on_text_speed_slider_value_changed(value: float) -> void:
	update_text_speed_slider(value);


func _on_text_speed_slider_drag_ended(_value_changed: bool) -> void:
	var value_to_save : float;
	if $Options/TextSpeed/TextSpeedSlider.value == MAX_TEXT_SPEED:
		value_to_save = -1;
	else:
		value_to_save = $Options/TextSpeed/TextSpeedSlider.value;

	Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_TEXT_SPEED, value_to_save);
	Inventory.get_config().save(Globals.USER_CONFIG_FILE);


func _on_delete_save_button_button_down() -> void:
	Inventory.get_save().clear();
	Inventory.get_save().save(Globals.USER_SAVE_FILE);
	$BackButton.grab_focus();
	$Options/DeleteSaveButton.disabled = true;
	SignalBus.save_deleted.emit();


func _on_dialog_noises_checkbox_toggled(toggled_on: bool) -> void:
	Inventory.get_config().set_value(Globals.CONFIG_CATEGORY_OPTIONS, Globals.CONFIG_KEY_VOICED_DIALOG, toggled_on);
	Inventory.get_config().save(Globals.USER_CONFIG_FILE);
