extends Control

var current_item_name : String = "";

var day_to_random_manager_dialog = {
	3 : [""]
}

var day_to_unique_manager_dialog = {
	1 : "",
	2 : "",
	3 : "",
	4 : "",
	5 : "",
	6 : "",
	7 : "",
	8 : "",
	9 : "",
	10 : "",
	11 : "",
	12 : "",
	13 : "",
	14 : ""
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
	if Input.is_action_just_pressed("accept"):
		$DynamicTextBox.display_next_line();

func update_wallet_text():
	$WalletText.text = "Wallet: $%d" % [Inventory.get_money_amount()];

func update_shown_items():
	$StoreItems/BaseballItem.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_BALL);
	$StoreItems/ClockItem.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_CLOCK);
	$StoreItems/KoboldItem.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_KOBOLD);



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
	try_buy_item(Globals.TRINKET_CLOCK, 10);

func _on_baseball_item_button_down() -> void:
	try_buy_item(Globals.TRINKET_BALL, 5);

func _on_kobold_item_button_down() -> void:
	try_buy_item(Globals.TRINKET_KOBOLD, 15);
