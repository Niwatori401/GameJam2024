class_name MainMenu extends Control




func _ready() -> void:
	make_config_and_save_files_if_needed();
	SignalBus.credit_splash_finished.connect(_on_credit_splash_finished);
	SignalBus.back_button_pressed.connect(hide_options_menu);

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit();


func _on_exit_game_button_button_up() -> void:
	get_tree().quit();


func _on_start_game_button_button_up() -> void:
	$Fader.darken(1);
	get_tree().create_timer(1.5).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/instances/cutscene/opening_cutscene.tscn"));


func _on_options_button_button_up() -> void:
	show_options_menu();
	
func _on_credit_splash_finished():
	$Fader.lighten(2);
	$AnimatedTitle.play("title_boil");
	# Slight offset to align with animation
	$AudioFader.play(0.1);
	$AudioFader.fade_in(4);

func show_options_menu():
	$Fader.darken(1);
	await get_tree().create_timer(1).timeout.connect(
		func (): 
			$OptionsMenu.show_options()
			);
			
func hide_options_menu():
	$Fader.visible = true;
	$Fader.lighten(1);
	$VBoxContainer/StartGameButton.grab_focus();

func make_config_and_save_files_if_needed():
	var save_load_status = ConfigFile.new().load(Globals.USER_SAVE_FILE);
	var config_load_status = ConfigFile.new().load(Globals.USER_CONFIG_FILE);

	if save_load_status != OK:
		ConfigFile.new().save(Globals.USER_SAVE_FILE);
		
	if config_load_status != OK:
		ConfigFile.new().save(Globals.USER_CONFIG_FILE);
