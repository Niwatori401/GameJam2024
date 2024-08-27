extends Control




var loading_next_area : bool = false;
var saveFile = ConfigFile.new();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var status = saveFile.load(Globals.USER_SAVE_FILE);
	if status != OK:
		printerr("Failed to load save in BreakRoom");

	
	$Fader.lighten(1);
	$WaterCoolerButton.grab_focus();
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
	$Fader.darken(SHORT_FADE_OUT_TIME);
	Utility.load_scene(SHORT_FADE_OUT_TIME, Globals.SCENE_EMPLOYEE_STORE);


func _on_return_to_work_button_button_down() -> void:
	$Fader.darken(LONG_FADE_OUT_TIME);
	Utility.load_scene(LONG_FADE_OUT_TIME, Globals.SCENE_POST_LUNCH_PRE_MAIN_GAME);
