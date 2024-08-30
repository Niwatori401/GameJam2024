extends Control

const INITIAL_FADE_IN_DELAY := 3;
#const FADE_TIME_BETWEEN_FRAMES := 0.5;
var cur_wait_time : float = 0;
var foreground_frame_index : int = 0;

@export var scene_to_load_upon_completion : String;

var cur_total_wait_time : float = 0;
var cur_fade_time : float = 0;

# Full of arrays of strings
var text : Array[Array] = [
	# Ends eating at table
	["[i]You sit down to eat your meager meal, slightly diconcerted at your cold reception. You're not having the best of days. You're tired, nobody's talking to you, and you feel like the walls are coming down on top of you.[/i]"],
	# Ends with on ground with manager in frame
	["[i]Then, the wall comes down on top of you.[/i]", "[i]And, along with it, a remarkably fat young woman.[/i]", "p:...", "c:...", "m:...", "m:Ah.", "c:S-sorry to intrude...on your lunch...I was...just leaving...", "m:Yes, you were.", "[i]You lock eyes with the client as she turns to leave. You're taken aback by just how large she is.[/i]", "[i]Her clothing is packed so tightly onto her meaty body that it's a miracle she's even allowed in public with how her shirt looks like it might explode off her at any given moment.[/i]", "[i]Every button is an autocannon waiting to be fired, the fabric wound around her so tightly it could probably restrain a large walrus.[/i]", "[i]Her richly padded, round face sports two pudgy chins, with the beginnings of a third apparently in development.[/i]"],
	# Ends at Hand shake
	["[i]For a brief moment, she stares at you, then suddenly grasps your hand and shakes it with the intensity of a cement mixer.[/i]", "c:Thank you!", "[i]You're basically whipped around like a piece of spaghetti for a few seconds, before the girl seems to remember herself, then looks behind her to see Management, her arms folded, a scowl darkly emblazoned on her face.[/i]"],

	# Crawling through hole
	["[i]Without another word, the girl lets go of you and scrambles back through the hole. You try to get a view of the room she came in through, but Management quickly blocks your view.[/i]"],
	
	# manager 1
	["m:Alright, back to work.", "p:.`.`.", "m:.`.`.", "p:.`.`.`no"],
	#manager miffed
	["m:[font_size=30][i]excuse me?[/i][/font_size]", "p:W-who was that girl?", "m:You don't need to know that.", "p:Why did she act like she knew who I was? I've never seen-", "m:That's not important. Get back to work. Now.", "p:What's going on here?"],
	#angry
	["m:IF I TELL YOU, WILL YOU LEAVE ME ALONE?", "p:.`.`.`Maybe."],
	#normal again
	["m:She's your.`.`.`recipient.", "m:The one you're signing the forms for. Sending the tubes to. Confirming deliveries to. Did you read your non-disclosure pamphlet?", "p:[i][font_size=30]`.`.`.yes?[/font_size][/i]", "m:Then you know what's in the tubes. What you're working towards.", "p:[i]I definitely know, but you should tell me anyway. For, um...morale?[/i]"],
	
	# ray gun
	["You may be a little young to remember, but when President Ray Gunn won re-election for the fifth time in 1996, he bolstered the economy by helping the nation's chocolate farmers.", "p:Oh, yeah, my grandpa used to tell me about the olden days--", "m:If you interrupt my expositional onslaught again, I will sell your vocal cords at my store starting tomorrow.", "Anyway,"],
	# vault
	["m:the Gunn administration left the country with a lot of surplus chocolate. Way more than we could export, and probably too much to eat.", "m:We stored the excess in a plethora of underground vaults for a few years.", "m:But, then we needed the space for the new administration's Pog collection, so the government devised a scheme to get rid of all of the chocolate.", "m:That girl is part of that scheme. The last week, you've been sending her chocolate through a tube system.", "m:She gets paid for every bar she eats, and it's quite lucrative. If she eats a few more tons, she might even able to pay off her student loans.", "m:That's where you come in. You stamp the delivery forms. You push the confirmations. You send the tubes down. And she eats it. It's a two way street, and you both do important work.", "p:But why was she--", "m:She should not have been where she was. I suspect she's been peering through the crack in the wall.", "m:Her job is to eat, not to interact with the outside world. I suppose we overlooked that aspect of her employment, so, naturally, she'd become curious.", "m:She asked for a feed to the security cameras so she could watch you work, just so she could do something other than eat all day.", "m:At first, we insisted this would take away from valuable ingestion time, but she was persistent, so we had a two-way feed installed.", "m:I suspect she'll want to talk to you now that the secret is out.", "m:I will allow these communications provided that you both continue to do your jobs.", "m:You are not to talk to anyone else about this. If you do..."],
	# HR
	["m:Are we clear? ``Good. I'll have your communications linked by tomorrow. Until then, continue to work as if you saw nothing."]
	];

var is_ending := false;
var scene_index : int = 0; 

var should_display_text := false;
func play_at_index(index : int):
	var scenes = $Scenes.get_children();
	
	for i in range(len(scenes)):
		if i == index:
			scenes[i].visible = true;
			scenes[i].play();
			scenes[i].animation_finished.connect(func(): 
				should_display_text = true;
				);
		else:
			scenes[i].visible = false;


func _ready() -> void:
	$BGM.fade_in(2);
	$DynamicTextBox.visible = false;
	$Fader.lighten(INITIAL_FADE_IN_DELAY);
	play_at_index(0);


func should_end_cutscene():
	if scene_index > len($Scenes.get_children()) - 1:
		return true;

func _process(delta: float) -> void:
	if is_ending:
		return;
		
	if should_end_cutscene():
		if not is_ending:
			$Fader.darken(2);
			$BGM.fade_out(2);
			Utility.load_scene(2, scene_to_load_upon_completion);
			is_ending = true;
		return;
	
	if should_display_text:
		should_display_text = false;
		$DynamicTextBox.display_new_text(text[scene_index]);
	
	if Input.is_action_just_pressed("accept"):
		$DynamicTextBox.display_next_line();	
		
		if $DynamicTextBox.is_finished():
			scene_index += 1;
			if should_end_cutscene():
				if not is_ending:
					$Fader.darken(2);
					$BGM.fade_out(2);
					Utility.load_scene(2, scene_to_load_upon_completion);
					is_ending = true;
				return;
			else:
				play_at_index(scene_index);


func hide_text_box():
	$DynamicTextBox.visible = false;

func show_text_box():
	$DynamicTextBox.visible = true;
