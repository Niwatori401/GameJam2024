class_name MainMenu extends Control



func _ready() -> void:
	
	if Inventory.is_first_day():
		Inventory.get_save().set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, 0);
		Inventory.get_save().save(Globals.USER_SAVE_FILE);
		$VBoxContainer/StartGameButton.text = "Start Game";
	else:
		$VBoxContainer/StartGameButton.text = "Continue";

	SignalBus.credit_splash_finished.connect(_on_credit_splash_finished);
	SignalBus.back_button_pressed.connect(hide_options_menu);
	SignalBus.save_deleted.connect(func() : $VBoxContainer/StartGameButton.text = "Start Game");
	$OptionsMenu/Options/DeleteSaveButton.disabled = false;
	
	$VBoxContainer/GalleryButton.disabled = not Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_PER_SE);
	

func _on_exit_game_button_button_up() -> void:
	get_tree().quit();


func _on_start_game_button_button_up() -> void:
	$Fader.darken(1);
	Utility.load_scene(1.5, Globals.SCENE_LEVEL_DISPATCH);

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
	get_tree().create_timer(1).timeout.connect(
		func (): 
			$OptionsMenu.show_options()
			);
			
func hide_options_menu():
	$Fader.visible = true;
	$Fader.lighten(1);
	$VBoxContainer/StartGameButton.grab_focus();


func _on_gallery_button_button_down() -> void:
	$Fader.darken(1);
	$AudioFader.fade_out(1);
	Utility.load_scene(1, Globals.SCENE_GALLERY);
