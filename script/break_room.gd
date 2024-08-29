extends Control


var room_textures_by_day = {
	3: preload("res://asset/background/break_room/break_room_1.png"),
	5: preload("res://asset/background/break_room/break_room_2.png"),
	6: preload("res://asset/background/break_room/break_room_3.png"),
	7: preload("res://asset/background/break_room/break_room_4.png"),
	8: preload("res://asset/background/break_room/break_room_5.png"),
}


var loading_next_area : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fader.lighten(1);
	$WaterCoolerButton.grab_focus();
	var day_number = floori(Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER))
	
	var is_day_7 = day_number == 7;
	$EmployeeStoreButton.disabled = is_day_7;
	$ManagerStanding.visible = is_day_7;

	var wall_texture : Texture2D;
	if day_number <= 3:
		wall_texture = room_textures_by_day[3];
	elif day_number <= 5:
		wall_texture = room_textures_by_day[5];
	elif day_number <= 6:
		wall_texture = room_textures_by_day[6];
	elif day_number <= 7:
		wall_texture = room_textures_by_day[7];	
	else:
		wall_texture = room_textures_by_day[8];
		
	$Background.texture = wall_texture;
		
	loading_next_area = false;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Prevents pressing two areas simultaneously
	if loading_next_area == true:
		return;


const LONG_FADE_OUT_TIME : float = 1.5;
const SHORT_FADE_OUT_TIME : float = 0.5;

func _on_water_cooler_button_button_down() -> void:
	$Fader.darken(SHORT_FADE_OUT_TIME);
	Utility.load_scene(SHORT_FADE_OUT_TIME, Globals.SCENE_WATER_COOLER);


func _on_employee_store_button_button_down() -> void:
	var is_first_time = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_IS_FIRST_STORE_VISIT, true);
	
	$Fader.darken(SHORT_FADE_OUT_TIME);
	
	if is_first_time:
		Utility.load_scene(SHORT_FADE_OUT_TIME, Globals.SCENE_STORE_FIRST_TIME_CUTSCENE);
	else:
		Utility.load_scene(SHORT_FADE_OUT_TIME, Globals.SCENE_EMPLOYEE_STORE);


func _on_return_to_work_button_button_down() -> void:
	$Fader.darken(LONG_FADE_OUT_TIME);
	Utility.load_scene(LONG_FADE_OUT_TIME, Globals.SCENE_POST_LUNCH_PRE_MAIN_GAME);
