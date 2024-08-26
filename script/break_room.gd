extends Control




var loading_next_area : bool = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fader.lighten(1);
	$EmployeeStoreButton.grab_focus();
	loading_next_area = false;
	set_buttons_disabled(false);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Prevents pressing two areas simultaneously
	if loading_next_area == true:
		return;

	
func set_buttons_disabled(is_disabled : bool) -> void:
	$WaterCoolerButton.disabled = is_disabled;
	$EmployeeStoreButton.disabled = is_disabled;
	$ReturnToWorkButton.disabled = is_disabled;


const LONG_FADE_OUT_TIME : float = 1.5;
const SHORT_FADE_OUT_TIME : float = 0.5;

func _on_water_cooler_button_button_down() -> void:
	$Fader.darken(SHORT_FADE_OUT_TIME);
	set_buttons_disabled(true);
	Utility.load_scene(SHORT_FADE_OUT_TIME, Globals.SCENE_WATER_COOLER);


func _on_employee_store_button_button_down() -> void:
	$Fader.darken(SHORT_FADE_OUT_TIME);
	set_buttons_disabled(true);
	Utility.load_scene(SHORT_FADE_OUT_TIME, Globals.SCENE_EMPLOYEE_STORE);


func _on_return_to_work_button_button_down() -> void:
	$Fader.darken(LONG_FADE_OUT_TIME);
	set_buttons_disabled(true);
	Utility.load_scene(LONG_FADE_OUT_TIME, Globals.SCENE_PRE_MAIN_GAME);
