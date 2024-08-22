class_name MainMenu extends Control



func _ready() -> void:
	$VBoxContainer/StartGameButton.grab_focus();
	$Fader.lighten(4);
	$AudioFader.fade_in(4);
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
