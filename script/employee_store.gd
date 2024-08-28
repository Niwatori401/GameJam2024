extends Control

var current_item_name : String = "";

func _ready() -> void:
	$Fader.lighten(1);
	SignalBus.store_item_selected.connect(set_text_for_currently_selected_item);
	SignalBus.no_item_selected.connect(hide_description);
	$WalletText.text = "Wallet: $%d" % [Inventory.get_money_amount()];
	$BackButton.grab_focus();

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		$DynamicTextBox.display_next_line();


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


func _on_clock_item_button_down() -> void:
	if Inventory.get_money_amount() >= 10:
		Inventory.unlock_trinket(Globals.TRINKET_CLOCK);
		Inventory.change_and_commit_money_amount(-10);


func _on_baseball_item_button_down() -> void:
	if Inventory.get_money_amount() >= 5:
		Inventory.unlock_trinket(Globals.TRINKET_BALL);
		Inventory.change_and_commit_money_amount(-5);
		


func _on_kobold_item_button_down() -> void:
	if Inventory.get_money_amount() >= 15:
		Inventory.unlock_trinket(Globals.TRINKET_KOBOLD);
		Inventory.change_and_commit_money_amount(-15);
