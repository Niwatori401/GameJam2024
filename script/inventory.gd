extends Node

var trinkets = {
	"clock": false,
	"throw_ball": false,
	"kobold": false
}

var money : int = 0;

var save_file : ConfigFile = ConfigFile.new();

func _ready() -> void:
	var status = save_file.load(Globals.USER_SAVE_FILE);
	if status != OK:
		return;
		
	load_inventory_from_file();

func get_money_amount():
	return money;
	
func change_and_commit_money_amount(amount_to_change : int):
	money += amount_to_change;
	save_file.set_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_MONEY, money);
	save_file.save(Globals.USER_SAVE_FILE);

func is_trinket_unlocked(trinket_name : String) -> bool:
	if not trinkets.has(trinket_name):
		printerr("Invalid Trinket Name: %s" % [trinket_name]);

	return trinkets[trinket_name];

func unlock_trinket(trinket_name : String) -> void:
	if not trinkets.has(trinket_name):
		printerr("Invalid Trinket Name: %s" % [trinket_name]);
		
	trinkets[trinket_name] = true;
	save_trinkets_to_file();
	
func save_trinkets_to_file() -> void:
	save_file.set_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS, trinkets);
	save_file.save(Globals.USER_SAVE_FILE);

func load_inventory_from_file() -> void:
	if save_file.has_section_key(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS):
		trinkets = save_file.get_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_TRINKETS);
		
	money = save_file.get_value(Globals.SAVE_CATEGORY_INVENTORY, Globals.SAVE_KEY_MONEY, 0);
