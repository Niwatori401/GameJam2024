extends Node

func load_scene(delay_seconds : float, scene_location : String) -> void:
	get_tree().create_timer(delay_seconds).timeout.connect(func(): get_tree().change_scene_to_file(scene_location));
