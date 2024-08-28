extends Node2D

@export var show_pail := false;
@export var show_clipboard := false;
@export var show_message := false;





var day_splash_screens : Array[Texture2D] = [
	preload("res://asset/background/day_counter/day1.png"),
	preload("res://asset/background/day_counter/day2.png"),
	preload("res://asset/background/day_counter/day3.png"),
	preload("res://asset/background/day_counter/day4.png"),
	preload("res://asset/background/day_counter/day5.png"),
	preload("res://asset/background/day_counter/day6.png"),
	preload("res://asset/background/day_counter/day7.png"),
	preload("res://asset/background/day_counter/day8.png"),
	preload("res://asset/background/day_counter/day9.png"),
	preload("res://asset/background/day_counter/day10.png"),
	preload("res://asset/background/day_counter/day11.png"),
	preload("res://asset/background/day_counter/day12.png"),
	preload("res://asset/background/day_counter/day13.png"),
	preload("res://asset/background/day_counter/day14.png"),
	preload("res://asset/background/day_counter/day_x.png"),
]

var clipboard_messages = [
	#1
	"Welcome, new hire. 

Congratulations on your new position of 
[u][font_size=20][font=\"res://asset/font/michellefont/Michellefont-Regular.otf\"]Inventory Management Technician[/font][/font_size]       ![/u]
Your workflow is simple, but important. Simply stamp the incoming forms as they arrive on your desk. It might benefit you to get a rhythm going.

Failure to correctly process the required documents may result in early termination.

Welcome to the team!",
	#2
	"You came back. Good. Seeing as you're a veteran workforce member, you're now entitled to have a [b]lunch break[/b] in the middle of your shifts. Make sure you head to the company lunchroom at the [b]lunch whistle[/b]. Got that?
	
Oh, and I'll need you to start putting these [b]tubes[/b] in the [b]pneumatic launcher[/b] starting today, as well. It's not difficult, so even you should be able to manage. Good luck.",
	# 3
	"",
	# 4
	"",
	# 5
	"",
	# 6
	"",
	# 7
	"",
	# 8
	"",
	# 9
	"",
	# 10
	"",
	# 11
	"",
	# 12
	"",
	# 13
	"",
	# 14
	"",  
]

var day_number : float = 1;

func _ready() -> void:
	day_number = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, 1);
	show_only_unlocked_trinkets();
	var is_beginning_of_day = show_clipboard and show_message;
	if is_beginning_of_day:
		$NonGameOffice/TextureFader.texture = day_splash_screens[clampi(floori(day_number) - 1, 0, 14)];
		$NonGameOffice/TextureFader.lighten(2, 2);
		$NonGameOffice/Fader.visible = false;
	else:
		$NonGameOffice/TextureFader.visible = false;
		$NonGameOffice/Fader.lighten(2);

	
	
	$BGM.fade_in(2);
	
	$NonGameOffice/ClipBoard.visible = show_clipboard;
	$NonGameOffice/LunchPail.visible = show_pail;

	if show_clipboard:
		$NonGameOffice/ClipBoard.grab_focus();
	elif show_pail:
		$NonGameOffice/LunchPail.grab_focus();
		
	$NonGameOffice/StartPage.visible = should_show_start_page();
	$NonGameOffice/ManagementNote.visible = is_beginning_of_day and not should_show_start_page();


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		$NonGameOffice/PaperMessage.start_move_down();
		if paper_is_up:
			paper_viewed = true;
			paper_is_up = false;

func get_clipboard_text_for_day():
	return clipboard_messages[day_number - 1];


func should_show_start_page() -> bool:
	return (show_clipboard and (not show_message or get_clipboard_text_for_day() == "")) or paper_viewed;
	

var paper_viewed := false;
var is_loading := false;
var paper_is_up := false;
func _on_clip_board_button_down() -> void:
	if paper_is_up or is_loading:
		return;
	
	# start game
	if should_show_start_page():
		is_loading = true;
		$NonGameOffice/Fader.darken(3);
		Utility.load_scene(2.5, Globals.SCENE_MAIN_GAME);
		return;
		
	
	if show_message and not paper_viewed:
		var text_for_day : String = get_clipboard_text_for_day();
		const TRANSITION_TIME : float = 0.65;
		get_tree().create_timer(TRANSITION_TIME).timeout.connect(func(): 
			$NonGameOffice/StartPage.visible = true
			$NonGameOffice/ManagementNote.visible = false;
			);
		
		$NonGameOffice/PaperMessage.set_text(text_for_day);
		$NonGameOffice/PaperMessage.start_move_up(TRANSITION_TIME);
		paper_is_up = true;
		return;


func _on_lunch_pail_button_down() -> void:
	Utility.load_scene(3, Globals.SCENE_BREAK_ROOM);
	$NonGameOffice/Fader.darken(2.5);


func show_only_unlocked_trinkets():
	$Trinkets/ThrowBall.visible = Inventory.is_trinket_unlocked(Globals.TRINKET_BALL);
	$Trinkets/TrinketClock.visible = Inventory.is_trinket_unlocked(Globals.TRINKET_CLOCK);
	$Trinkets/KoboldTrinket.visible = Inventory.is_trinket_unlocked(Globals.TRINKET_KOBOLD);
