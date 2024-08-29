extends Control


@export var animation_duration_secs : float = 1;
var secs_per_frame : float;
var shady_sam_opened : bool = false;

var shady_sam_sprites : Array[Texture2D] = [
	preload("res://asset/background/water_cooler/ShadySamPaper/Shady_Sam.png"),
	preload("res://asset/background/water_cooler/ShadySamPaper/Shady_Sam_2.png"),
	preload("res://asset/background/water_cooler/ShadySamPaper/Shady_Sam_3.png"),
]

var shady_sam_hover_sprites : Array[Texture2D] = [
	preload("res://asset/background/water_cooler/ShadySamPaper/shady_sam_hover.png"),
	preload("res://asset/background/water_cooler/ShadySamPaper/shady_sam_hover_3.png")
]

var shady_sam_click_mask_sprites : Array[BitMap] = [
	preload("res://asset/background/water_cooler/ShadySamPaper/shady_sam_button_mask.png"),
	preload("res://asset/background/water_cooler/ShadySamPaper/shady_sam_button_mask_3.png")
]

var break_room_theme : AudioStreamOggVorbis = preload("res://asset/sound/music/breakroom_theme.ogg");

func _ready():
	SignalBus.store_item_selected.connect(set_text_for_currently_selected_item);
	SignalBus.no_item_selected.connect(hide_description);
	update_wallet_text();
	update_shown_items();
	$BackButton.grab_focus();
	
	$StoreItems.visible = false;
	$Fader.lighten(0.5);
	var day_number = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER);
	if day_number == null:
		printerr("Day number failed to load in water_cooler");
		
	if floori(day_number) == 7 or floori(day_number) < 4:
		$ShadySamButton.visible = false;
		$AudioFader.stream = break_room_theme;
		$AudioFader.stream.loop = true;
		
	$AudioFader.fade_in(0.5);
	$AudioFader.play();
	secs_per_frame = animation_duration_secs / len(shady_sam_sprites);

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept") and not $DynamicTextBox.is_finished() and $DynamicTextBox.done_with_last_letter():
		$DynamicTextBox.display_next_line();

func _on_back_button_button_down() -> void:
	$Fader.darken(0.5);
	$AudioFader.fade_out(0.5);

	Utility.load_scene(0.5, Globals.SCENE_BREAK_ROOM);


func _on_not_on_shady_sam_button_focus_entered() -> void:
	if (not $ShadySamButton.has_focus() or not $ShadySamButton.is_hovered()) and shady_sam_opened:
		reverse_animation();


func _on_shady_sam_button_button_down() -> void:
	play_sam_dialog();
	play_animation();
	

func reverse_animation():
	shady_sam_opened = false;
	get_tree().create_timer(1 * secs_per_frame).timeout.connect(func (): 
		$ShadySamButton.texture_normal = shady_sam_sprites[1];
		$ShadySamButton.texture_hover = null;
		$StoreItems.visible = false;
		);
	get_tree().create_timer(2 * secs_per_frame).timeout.connect(func (): 
		$ShadySamButton.texture_normal = shady_sam_sprites[0];
		$ShadySamButton.texture_hover = shady_sam_hover_sprites[0];
		$ShadySamButton.texture_click_mask = shady_sam_click_mask_sprites[0];
		shady_sam_opened = false
		$ShadySamButton.disabled = false);


func play_animation():
	get_tree().create_timer(1 * secs_per_frame).timeout.connect(func (): 
		$ShadySamButton.texture_normal = shady_sam_sprites[1];
		$ShadySamButton.texture_hover = null;
		);
	get_tree().create_timer(2 * secs_per_frame).timeout.connect(func (): 
		$ShadySamButton.texture_normal = shady_sam_sprites[2];
		$ShadySamButton.texture_hover = shady_sam_hover_sprites[1];
		$ShadySamButton.texture_click_mask = shady_sam_click_mask_sprites[1];
		$StoreItems.visible = true;
		shady_sam_opened = true
		$ShadySamButton.disabled = true);



var sam_purchase_dialog_random = [
	"s:Great purchase! Of all the purchases, that was one of 'em.",
	"s:Yeah, that's a good piece. Which one is that again? Oh. Wow.",
	"s:No refunds. Who would you even complain to?"
]

var sam_purchase_fail_dialog_random = [
	"s:What, I look like a charity to you?",
	"s:You ain't got enough for that.",
	"s:Hey, c'mon, this is a legitimate business. I even stole a certificate to prove it."
]

func display_successful_purchase_dialog():
	$DynamicTextBox.display_new_text([sam_purchase_dialog_random.pick_random()])
	
func display_failed_purchase_dialog():
	$DynamicTextBox.display_new_text([sam_purchase_fail_dialog_random.pick_random()])




var current_item_name := "";
func set_text_for_currently_selected_item(item_name, description, price) -> void:
	if current_item_name == item_name:
		return;
	
	current_item_name = item_name;
	$DynamicTextBox.display_new_text(["[center][font_size=55]%s[/font_size][/center]\n%s\nPrice: %d" % [item_name, description, price]]);

func hide_description():
	current_item_name = "";
	$DynamicTextBox.display_next_line();
	


func update_shown_items():
	$StoreItems/StoreItem_1.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_1);
	$StoreItems/StoreItem_2.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_2);
	$StoreItems/StoreItem_3.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_3);
	$StoreItems/StoreItem_4.disabled = Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_4);



func update_wallet_text():
	$WalletText.text = "Wallet: $%d" % [Inventory.get_money_amount()];



var random_sam_dialog = [
	"s:If I don't move, she can't see me. That's the trick.",
	"s:People say I look sketchy.",
	"s:Don't ask me to store these for you. I'm a terrible place holder.",
	"s:You know anyone that buys water coolers? No reason.",
	"s:Where do I get this stuff? Don't worry about it.",
	"s:You know, I'm a nice guy, on paper.",
	"s:I'm pretty tough, you know? I don't fold easily.",
	"s:My prices are firm, kid. I gotta stay within the margins.",
	"s:Come see me anytime, friend. I'm here day or night. Actually, I sleep here. It's a problem."
]

var random_lines_count : int = 0;
const MAX_RANDOM_LINES_PER_DAY = 2;
func play_sam_dialog() -> void:
	var sam_first_time = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_IS_FIRST_SAM_VISIT, true);
	
	if sam_first_time:
		$DynamicTextBox.display_new_text(["s:Psst. Hey you! Yeah, you.", "You're the new kid? I got some...interestin' stuff. Don't tell nobody. For you, real cheap. Won't sell to nobody else. Don't worry about it.", "Now are youse gonna buy somethin', or just stand there lookin' like a sad puppy?"])
		Inventory.get_save().set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_IS_FIRST_SAM_VISIT, false);
		Inventory.get_save().save(Globals.USER_SAVE_FILE);
	else:
		if random_lines_count >= MAX_RANDOM_LINES_PER_DAY:
			return;
		
		$DynamicTextBox.display_new_text([random_sam_dialog.pick_random()]);
		random_lines_count += 1;


func try_buy_item(item_name : String, cost : int):
	if Inventory.is_trinket_unlocked(item_name):
		return;
		
	if Inventory.get_money_amount() >= cost:
		$BuySFX.play();
		Inventory.unlock_trinket(item_name);
		Inventory.change_and_commit_money_amount(-cost);
		display_successful_purchase_dialog();
		update_shown_items();
		update_wallet_text();
	else:
		display_failed_purchase_dialog();
		$FailSFX.play(); 

func _on_store_item_1_button_down() -> void:
	try_buy_item(Globals.TRINKET_GALLERY_1, $StoreItems/StoreItem_1.cost);

func _on_store_item_2_button_down() -> void:
	try_buy_item(Globals.TRINKET_GALLERY_2, $StoreItems/StoreItem_2.cost);

func _on_store_item_3_button_down() -> void:
	try_buy_item(Globals.TRINKET_GALLERY_3, $StoreItems/StoreItem_3.cost);

func _on_store_item_4_button_down() -> void:
	try_buy_item(Globals.TRINKET_GALLERY_4, $StoreItems/StoreItem_4.cost);
