extends Control



func _ready() -> void:
	$Fader.lighten(4);


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit();


func _on_exit_game_button_button_up() -> void:
	get_tree().quit();


func _on_start_game_button_button_up() -> void:
	$Fader.darken(1);
	get_tree().create_timer(1.5).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"));
