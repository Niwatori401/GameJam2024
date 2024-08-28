extends Node

const USER_SAVE_FILE := "user://save.ini";
const USER_CONFIG_FILE := "user://config.cfg";

const CONFIG_CATEGORY_OPTIONS := "Options";
const CONFIG_KEY_TEXT_SPEED := "text_speed";
const CONFIG_KEY_VOLUME := "master_volume";
const CONFIG_KEY_FULLSCREEN := "is_fullscreen";
const CONFIG_KEY_CONTROL_SCEME := "control_scheme";
const CONFIG_KEY_RESOLUTION := "resolution";

const SAVE_CATEGORY_INVENTORY := "Inventory";
const SAVE_KEY_MONEY := "money";
const SAVE_KEY_TRINKETS := "trinkets";


const SAVE_CATEGORY_PROGRESS := "Progress";
const SAVE_KEY_THROWN_BALL_IMPACT_INDEX := "thrown_ball_impact_index";
const SAVE_KEY_DAY_NUMBER := "day_number";
const SAVE_KEY_IS_FIRST_HR_VISIT := "is_first_hr_visit";
const SAVE_KEY_IS_FIRST_STORE_VISIT := "is_first_store_visit";

const SCENE_LEVEL_DISPATCH := "res://scene/level_dispatch.tscn";
const SCENE_OPENING_CUTSCENE := "res://scene/instances/cutscene/opening_cutscene.tscn";
const SCENE_HR_FIRST_TIME_CUTSCENE := "res://scene/instances/cutscene/hr_1st_encounter.tscn";
const SCENE_STORE_FIRST_TIME_CUTSCENE := "res://scene/instances/cutscene/employee_shop_cutscene.tscn";
const SCENE_BREAK_ROOM := "res://scene/break_room.tscn";
const SCENE_MAIN_GAME := "res://scene/main_game.tscn";
const SCENE_PRE_MAIN_GAME := "res://scene/pre_main_game.tscn";
const SCENE_PRE_LUNCH_MAIN_GAME := "res://scene/prelunch_main_game.tscn";
const SCENE_POST_LUNCH_PRE_MAIN_GAME := "res://scene/post_lunch_pre_main_game.tscn";
const SCENE_MAIN_MENU := "res://scene/main_menu.tscn";
const SCENE_OPTIONS_MENU := "res://scene/options_menu.tscn";
const SCENE_WATER_COOLER := "res://scene/water_cooler.tscn";
const SCENE_EMPLOYEE_STORE := "res://scene/employee_store.tscn";
const SCENE_GAME_OVER := "res://scene/game_over.tscn";


const TRINKET_KOBOLD := "kobold_bobble_head_trinket";
const TRINKET_BALL := "throw_ball_trinket";
const TRINKET_CLOCK := "clock_trinket";
