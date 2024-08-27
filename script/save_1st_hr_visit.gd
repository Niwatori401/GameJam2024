extends Node


var saveFile = ConfigFile.new();
func _ready() -> void:
	var status = saveFile.load(Globals.USER_SAVE_FILE);
	if status != OK:
		printerr("Failed to load save in extra_script on HRFirstEncounter");
		return;
		
	saveFile.set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_HAD_FIRST_HR_VISIT, false);
	saveFile.save(Globals.USER_SAVE_FILE);
