extends Control

var current_item_name : String = "";

# From days 3 - 6
var random_manager_dialog = [
	"m:Seriously, you're like a mouse. How have you survived this long?",
	"m:You really do not present a picture of confidence.",
	"m:If you find me to be condescending, then stop finding me.",
	"m:Has anyone ever told you that you look like a wet cat?",
	"m:If I give you another sandwich, will you stop bothering me?",
	"m:No, you can't take me to dinner. You couldn't afford it.",
	"m:Wow, you really will buy anything."
	]
	
var current_day_dialog_index : int = 0;
var day_to_unique_manager_dialog = {
	1 : [],
	2 : ["m:Yes, I've seen the crack in the wall. It's being sorted.", "m:You haven't seen a shadowy man running around, have you?"],
	3 : ["m:I told you, it's being sorted. Stop worrying about it.", "m:I need coffee. We don't have coffee. I am one missed latte away from going postal."],
	4 : ["m:Yes, I see [i]him[/i]. We all see [i]him[/i].","m:He's just lucky my jurisdiction doesn't cover the water cooler. Crafty little git."],
	5 : ["m:OH, THE CRACK IS GETTING BIGGER? THANKS EINSTEIN. I'LL GET RIGHT ON IT."],
	6 : ["m:Don't touch the wall. Don't go near the wall. Don't even think about the wall.", "m:Those earlier tremors were from a completely unrelated earthquake.", "m:Yes, an earthquake. At this time of day, in this part of the country, localized entirely within this office."],
	7 : [],
	8 : [],
	9 : [],
	10 : [],
	11 : [],
	12 : [],
	13 : [],
	14 : []
}



func _ready() -> void:
	$Fader.lighten(1);
	$AudioFader.fade_in(1);
	SignalBus.store_item_selected.connect(set_text_for_currently_selected_item);
	SignalBus.no_item_selected.connect(hide_description);
	update_wallet_text();
	update_shown_items();
	$BackButton.grab_focus();


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept") and not $DynamicTextBox.is_finished() and $DynamicTextBox.done_with_last_letter():
		$DynamicTextBox.display_next_line();

func update_wallet_text():
	$WalletText.text = "Wallet: $%d" % [Inventory.get_money_amount()];

func update_shown_items():
	$StoreItems/BaseballItem.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_BALL);
	$StoreItems/ClockItem.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_CLOCK);
	$StoreItems/KoboldItem.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_KOBOLD);
	$StoreItems/BloopyItem.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_BLOOPY);

func set_text_for_currently_selected_item(item_name, description, price) -> void:
	if current_item_name == item_name:
		return;
	
	current_item_name = item_name;
	$DynamicTextBox.display_new_text(["[center][font_size=55]%s[/font_size][/center]\n%s\nPrice: %d" % [item_name, description, price]]);

func hide_description():
	current_item_name = "";
	$DynamicTextBox.display_next_line();

func _on_back_button_button_down() -> void:
	Utility.load_scene(1, Globals.SCENE_BREAK_ROOM);
	$Fader.darken(1);
	$AudioFader.fade_out(1);


func try_buy_item(item_name : String, cost : int):
	if Inventory.is_trinket_unlocked(item_name):
		return;
		
	if Inventory.get_money_amount() >= cost:
		$BuySFX.play();
		Inventory.unlock_trinket(item_name);
		Inventory.change_and_commit_money_amount(-cost);
		update_shown_items();
		update_wallet_text();
	else:
		$FailSFX.play();

func _on_clock_item_button_down() -> void:
	try_buy_item(Globals.TRINKET_CLOCK, $StoreItems/ClockItem.cost);

func _on_baseball_item_button_down() -> void:
	try_buy_item(Globals.TRINKET_BALL, $StoreItems/BaseballItem.cost);

func _on_kobold_item_button_down() -> void:
	try_buy_item(Globals.TRINKET_KOBOLD, $StoreItems/KoboldItem.cost);


func _on_bloopy_item_button_down() -> void:
	try_buy_item(Globals.TRINKET_BLOOPY, $StoreItems/BloopyItem.cost);


var random_lines_count : int = 0;
const MAX_RANDOM_LINES_PER_DAY = 2;
func _on_manager_button_button_down() -> void:
	var current_day : int = floori(Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER));
	if len(day_to_unique_manager_dialog[current_day]) > current_day_dialog_index:
		$DynamicTextBox.display_new_text([day_to_unique_manager_dialog[current_day][current_day_dialog_index]]);
		current_day_dialog_index += 1;
		return;
	else:
		if random_lines_count >= MAX_RANDOM_LINES_PER_DAY:
			return;
		
		$DynamicTextBox.display_new_text([random_manager_dialog.pick_random()]);
		random_lines_count += 1;
