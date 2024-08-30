extends Node

var trinkets = {
	Globals.TRINKET_CLOCK: false,
	Globals.TRINKET_BALL: false,
	Globals.TRINKET_KOBOLD: false,
	Globals.TRINKET_BLOOPY: false,
	Globals.TRINKET_GALLERY_1: false,
	Globals.TRINKET_GALLERY_2: false,
	Globals.TRINKET_GALLERY_3: false,
	Globals.TRINKET_GALLERY_4: false,
}

var money : int = 0;

var save_file : ConfigFile = ConfigFile.new();
var config_file : ConfigFile = ConfigFile.new();

func _ready() -> void:
	make_config_and_save_files_if_needed();
	save_file.load(Globals.USER_SAVE_FILE);
	config_file.load(Globals.USER_CONFIG_FILE);
		
	SignalBus.save_deleted.connect(load_inventory_from_file);
	load_inventory_from_file();

func get_money_amount():
	return money;

func get_save():
	return save_file;

func get_config():
	return config_file;

func make_config_and_save_files_if_needed():
	config_file = ConfigFile.new();
	save_file = ConfigFile.new();
	
	var save_load_status = save_file.load(Globals.USER_SAVE_FILE);
	var config_load_status = config_file.load(Globals.USER_CONFIG_FILE);

	if save_load_status != OK:
		save_file = ConfigFile.new();
		save_file.save(Globals.USER_SAVE_FILE);
		
	if config_load_status != OK:
		config_file = ConfigFile.new();
		config_file.save(Globals.USER_CONFIG_FILE);



func is_first_day() -> bool:
	# Makes level dispatcher work correctly
	return not get_save().has_section_key(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER);
		
func change_and_commit_money_amount(amount_to_change : int):
	money += amount_to_change;
	save_file.set_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_MONEY, money);
	save_file.save(Globals.USER_SAVE_FILE);

func is_trinket_unlocked(trinket_name : String) -> bool:
	if not trinkets.has(trinket_name):
		printerr("Invalid Trinket Name: %s" % [trinket_name]);
		return false;

	return trinkets[trinket_name];

func unlock_trinket(trinket_name : String) -> void:
	if not trinkets.has(trinket_name):
		printerr("Invalid Trinket Name: %s" % [trinket_name]);
		
	trinkets[trinket_name] = true;
	save_trinkets_to_file();
	
func save_trinkets_to_file() -> void:
	save_file.set_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS, trinkets);
	save_file.save(Globals.USER_SAVE_FILE);

func reset_trinkets():
	for key in trinkets.keys():
		trinkets[key] = false;
		
func load_inventory_from_file() -> void:
	if save_file.has_section_key(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS):
		trinkets = save_file.get_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS);
	else:
		reset_trinkets();
		
	money = save_file.get_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_MONEY, 0);
