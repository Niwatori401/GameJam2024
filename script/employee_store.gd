extends Control

var current_item_name : String = "";

func _ready() -> void:
	$Fader.lighten(1);
	$Background_1.visible = true;
	$Background_2.visible = false;
	SignalBus.store_item_selected.connect(set_text_for_currently_selected_item);
	SignalBus.no_item_selected.connect(hide_description);
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
	$DynamicTextBox.display_next_line();

func _on_back_button_button_down() -> void:
	Utility.load_scene(1, Globals.SCENE_BREAK_ROOM);
	$Fader.darken(1);
