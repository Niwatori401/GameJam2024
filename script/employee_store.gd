extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background_1.visible = randi_range(0, 1) == 0;
	$Background_2.visible = not $Background_1.visible;
	SignalBus.store_item_selected.connect(set_text_for_currently_selected_item);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		$DynamicTextBox.display_next_line();


func set_text_for_currently_selected_item(item_name, description, price) -> void:
	$DynamicTextBox.display_new_text(["[center][font_size=100]%s[/font_size][/center]\n%s\nPrice: %d" % [item_name, description, price]]);
