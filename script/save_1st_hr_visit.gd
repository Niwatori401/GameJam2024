extends Node


func _ready() -> void:
	Inventory.get_save().set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_IS_FIRST_HR_VISIT, false);
	Inventory.get_save().save(Globals.USER_SAVE_FILE);
