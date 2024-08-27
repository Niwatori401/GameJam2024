extends Node


func _ready() -> void:
	var saveFile := ConfigFile.new();
	saveFile.load(Globals.USER_SAVE_FILE);
	var day_number = saveFile.get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, 0);
	
	if day_number == 0:
		saveFile.set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, 1);
		saveFile.save(Globals.USER_SAVE_FILE);
		Utility.load_scene(0, Globals.SCENE_OPENING_CUTSCENE);
	elif abs(day_number - roundi(day_number)) > 0.002:
		Utility.load_scene(0, Globals.SCENE_POST_LUNCH_PRE_MAIN_GAME);
	else:
		Utility.load_scene(0, Globals.SCENE_PRE_MAIN_GAME);
	
	return;
	
