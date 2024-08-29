extends Node2D

@export var show_pail := false;
@export var show_clipboard := false;
@export var show_message := false;
@export var end_of_day := false;




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
Your workflow is simple, but important. Simply stamp the incoming forms as they arrive on your desk. Instructions will be shown on the monitor to your left. It might benefit you to get a rhythm going.

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

var day_to_cam_state = {
	"first_briefing": [
		Enums.CLIENT_CAM_STATE.WORRIED, 
		Enums.CLIENT_CAM_STATE.HAPPY,
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.HAPPY,
		],
	8: [
		Enums.CLIENT_CAM_STATE.HAPPY,
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.WORRIED,
		Enums.CLIENT_CAM_STATE.WORRIED,
		Enums.CLIENT_CAM_STATE.HAPPY,
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.HAPPY,
		Enums.CLIENT_CAM_STATE.WORRIED,
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.HAPPY
		],
	9: [
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.HAPPY,
		Enums.CLIENT_CAM_STATE.WORRIED,
		Enums.CLIENT_CAM_STATE.HAPPY,
		Enums.CLIENT_CAM_STATE.WORRIED,
		Enums.CLIENT_CAM_STATE.WORRIED,
		Enums.CLIENT_CAM_STATE.HAPPY
		],
	10: [
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_2
		],
	11: [
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.WORRIED,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_2,
		Enums.CLIENT_CAM_STATE.POSITIVE,
		Enums.CLIENT_CAM_STATE.SPECIAL_2,
		],
	12: [
		Enums.CLIENT_CAM_STATE.HAPPY,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_1
		],
	13: [
		Enums.CLIENT_CAM_STATE.SPECIAL_2,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_3,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_4,
		Enums.CLIENT_CAM_STATE.SPECIAL_3
		],
	14: [
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_1,
		Enums.CLIENT_CAM_STATE.SPECIAL_2,
		Enums.CLIENT_CAM_STATE.SPECIAL_3
		],
}

var day_to_text = {
	"first_briefing": [
		"c:Umm...h-hello? Can you hear me? Okay, good.", 
		"c:It's nice to uh, meet you, I guess? Even though we weren't supposed to, heh...",
		"c:I'm gonna be a little busy, um...working? But we can talk more at the end of the day, if you want! That'd make us both feel better, right?",
		"c:Well, see you then! Work extra hard for me, okay?"
		],
	8: [
		"c:Great wOOOUUUARP....work! That was your best performance yet, at least on the flavor front.",
		"c:I'm pretty sure you can tell, but I'm a lot bigger than I was yesterday...not that I mind! The chocolate is delicious, and it's nice to be able to chat with co-workers!",
		"c:The warehouse they're keeping me in isn't what you'd expect. It's not too bright, it's cozy, and I've even got internet access.",
		"c:Although, heh...I can't imagine I'll be able to use it for much longer, at this rate. So you'll keep me company instead, right?",
		"p:Sure.",
		"c:I'm so glad we're on the same page...it makes me excited to come to work in the morning! Which is...incidentally, the exact same place where I sleep. But enough about me, how are you?",
		"p:I'm...better. I wasn't sure at first, but I think I like it here.",
		"c:Oh, that's great! This place is great! Maybe I'll share some of the chocolate with you some time, you have to try it, it's delicious!",
		"c:But...pretty soon here, I'm probably not gonna be able to bother you in the lunch room. It's getting REALLY hard to move.",
		"c:But oddly--it's a pleasant feeling, so plush and comfortable--and I have you to thank for that.",
		"c:You must be tired after working so hard, so I'll let you get back home. But don't worry, I'll be waiting for you right here!"
		],
	9: [
		"c:Hi! So, it's official--I'm stuck. I've eaten SO much chocolate that I can't move. That's super impressive, right?",
		"c:I was thinking deserve some sort of prize or promotion for my work, because I don't think anyone's ever eaten so much chocolate.",
		"c:But do you think the prize could just be more chocolate? 'Cause that sounds way more my tempo.",
		"c:You'd think that being an immobile pile of fat wouldn't be terribly exciting, but it's actually pretty awesome. I get to watch whatever I want, eat whatever I want, and talk to you all day, every day.",
		"c:And the bigger I get, the more I get paid! I'd say you should join me, but someone's gotta do the important stuff, you know?",
		"p:Uh...",
		"c:Oh, you're right, I probably wouldn't share. Not that you don't deserve it, I just can't help myself...well, see you tomorrow!"
		],
	10: [
		"c:So...I've gotten REALLY big. I didn't even know people could GET this big. I figure if I keep going, I'll be able to come visit you in another way...",
		"c:I kinda can't really move at all anymore, but I'm getting hungrier every day.",
		"c:I can't really see anything past my damn cheeks anymore, so I'm kind of in a weird spot where I'd like to watch some stuff, but I wanna keep eating.",
		"c:I guess it's a sacrifice we'll have to make. For science, right?",
		"p:For science.",
		"c:I wonder if they'll give me a Nobel prize..."
		],
	11: [
		"c:Hfff...hey...so, today, I noticed the room was getting a little small...and this isn't a small room.",
		"c:I-I'm not saying it's a problem or anything! Just that, um, those wall repairs might've been a little pointless...",
		"c:I can't even move my-hffff- head anymore. It's kind of a weird feeling, like I'm being hugged from every angle. But it's not unpleasant, you know?",
		"c:I'm kinda curious to see what happens if I...huff... keep going...I'm sure it's for a good cause...and even if it's not, what am I gonna do, refuse? As if.",
		"p:I'm sure they'd let you stop if you asked.",
		"c:Could you imagine that...hah... conversation?'Yeah, sure, let's get you a desk job.' And no more chocolate whenever I wanted? Just thinking about it is making me...mmm... hungry.",
		],
	12: [
		"c:Haaa...haaa... this is...incredible. I'm...",
		"c:I'm gonna ask...for a...hfff... feeding tube. Just...hnnn...think about it...chocolate every second of evvUUURRRRrry day...",
		"c:That might mean...hah...more work for you...but...you don't mind, right?",
		"c:You don't mind...haaaa...."
		],
	13: [
		"c:*ulp* *glllp* *grrrkk*",
		"c:Ahhh...h-hello... look at me! I can feel every part of me from so f-faaar away...hfff...",
		"c:Sorry, I have t---*ulp* *glp* *guulp* *glp*",
		"c:I w-wanna talk, I do, I just...I just HAVE t-- *gulp* *ulp*",
		"c:G-gonna...break...hahhh..the walls...they're not gonna...last...I'm amazing...but y-you're even more amazing for helping me get this f-far... I need...",
		"c:*ulp*`.`.`.` *ulp*``.``.``.``*ggglp*"
		],
	14: [
		"[i]You tune in, but she doesn't respond immediately. She seems to be lost in blissful gluttony.[/i]",
		"c:*ulp*`.`.`.` *glp*``.``.``.``*glllp*",
		"[i]She makes a noise of acknowledgement, but she doesn't stop gulping. It doesn't seem like you'll be able to have much more conversation.[/i]",
		"p:You've really become a workaholic, huh?",
		"[i]She makes a cute noise somewhere between a giggle and a swallow, trying to move her impossibly flabby neck. It wobbles completely out of control, sending waves of fat cascading towards the camera`.`.`.`` Then--[/i]",
		"...",
		"..?",
		"..!"
		],
}

var dark_office_bg = preload("res://asset/background/office_background_dark.png");
var dark_computer = preload("res://asset/desk_trinkets/computer/computer_dark.png");
var dark_desk = preload("res://asset/desk_dark.png");

var day_number : float = 1;

func _ready() -> void:
	day_number = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER, 1);
	show_only_unlocked_trinkets();
	if end_of_day:
		$Background.texture = dark_office_bg;
		$Desk.texture = dark_desk;
		$Computer.texture = dark_computer;
	$Trinkets/ClientCam.visible = day_number >= 8;
	$NonGameOffice/CamButton.visible = (day_number >= 8 and end_of_day) or (day_number == 8 and show_message);
	var is_beginning_of_day = show_clipboard and show_message;
	if is_beginning_of_day:
		$DayStartFX.play();
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

var cam_state_index : int = 0;

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		$NonGameOffice/DynamicTextBox.display_next_line();
		cam_state_index += 1;
		if $NonGameOffice/DynamicTextBox.is_finished():
			SignalBus.client_cam_state_changed.emit(Enums.CLIENT_CAM_STATE.OFF);
			$NonGameOffice/CamButton.visible = false;
			return;
		
		if day_number == 8:
			SignalBus.client_cam_state_changed.emit(day_to_cam_state["first_briefing"][cam_state_index]);
		else:
			SignalBus.client_cam_state_changed.emit(day_to_cam_state[roundi(day_number - 1)][cam_state_index]);

			
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


func _on_cam_button_button_down() -> void:
	if day_number == 8:
		$NonGameOffice/DynamicTextBox.display_new_text(day_to_text["first_briefing"]);
		SignalBus.client_cam_state_changed.emit(day_to_cam_state["first_briefing"][0]);
	else:
		$NonGameOffice/DynamicTextBox.display_new_text(day_to_text[roundi(day_number - 1)]);
		SignalBus.client_cam_state_changed.emit(day_to_cam_state[roundi(day_number - 1)][0]);
		


func _on_keys_button_down() -> void:
	Utility.load_scene(3, Globals.SCENE_PRE_MAIN_GAME);
	$NonGameOffice/Fader.darken(2.5);
