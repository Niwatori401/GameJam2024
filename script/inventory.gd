extends Node

var trinkets = {
	"clock": false,
	"throw_ball": false
}

var save_file : ConfigFile = ConfigFile.new();

func _ready() -> void:
	var status = save_file.load(Globals.USER_SAVE_FILE);
	if status != OK:
		return;
		
	load_inventory_from_file();
	
func is_trinket_unlocked(trinket_name : String) -> bool:
	if not trinkets.has(trinket_name):
		printerr("Invalid Trinket Name: %s" % [trinket_name]);

	return trinkets[trinket_name];

func unlock_trinket(trinket_name : String) -> void:
	if not trinkets.has(trinket_name):
		printerr("Invalid Trinket Name: %s" % [trinket_name]);
		
	trinkets[trinket_name] = true;
	save_inventory_to_file();
	
func save_inventory_to_file() -> void:
	save_file.set_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS, trinkets);
	save_file.save(Globals.USER_SAVE_FILE);

func load_inventory_from_file() -> void:
	if save_file.has_section_key(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS):
		trinkets = save_file.get_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS);
