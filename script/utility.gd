extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_8"):
		get_tree().quit();

func load_scene(delay_seconds : float, scene_location : String) -> void:
	get_tree().create_timer(delay_seconds).timeout.connect(func(): get_tree().change_scene_to_file(scene_location));
