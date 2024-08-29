extends Node2D
# OFF, BODY, HAPPY, POSITIVE, PROUD, WORRIED

var day_to_cam_graphics = {
	# Day 8 morning
	8 : {
		Enums.CLIENT_CAM_STATE.OFF       : preload("res://asset/desk_trinkets/client_cam/Client_screen_off.png"),
		Enums.CLIENT_CAM_STATE.BODY      : null,
		Enums.CLIENT_CAM_STATE.HAPPY     : preload("res://asset/desk_trinkets/client_cam/Stage 1/Client_Screen_1_Happy.png"),
		Enums.CLIENT_CAM_STATE.POSITIVE  : preload("res://asset/desk_trinkets/client_cam/Stage 1/Client_Screen_1_Positive.png"),
		Enums.CLIENT_CAM_STATE.WORRIED   : preload("res://asset/desk_trinkets/client_cam/Stage 1/Client_Screen_1_Worried.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_1 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_2 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_3 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_4 : null,
	},
	# Day 8 evening
	9 : {
		Enums.CLIENT_CAM_STATE.OFF       : preload("res://asset/desk_trinkets/client_cam/Client_screen_off.png"),
		Enums.CLIENT_CAM_STATE.BODY      : null,
		Enums.CLIENT_CAM_STATE.HAPPY     : preload("res://asset/desk_trinkets/client_cam/Stage 1/Client_Screen_1_Happy.png"),
		Enums.CLIENT_CAM_STATE.POSITIVE  : preload("res://asset/desk_trinkets/client_cam/Stage 1/Client_Screen_1_Positive.png"),
		Enums.CLIENT_CAM_STATE.WORRIED   : preload("res://asset/desk_trinkets/client_cam/Stage 1/Client_Screen_1_Worried.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_1 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_2 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_3 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_4 : null,
	},
	10: {
		Enums.CLIENT_CAM_STATE.OFF       : preload("res://asset/desk_trinkets/client_cam/Client_screen_off.png"),
		Enums.CLIENT_CAM_STATE.BODY      : null,
		Enums.CLIENT_CAM_STATE.HAPPY     : preload("res://asset/desk_trinkets/client_cam/Stage 2/Client_Screen_2_Happy.png"),
		Enums.CLIENT_CAM_STATE.POSITIVE  : preload("res://asset/desk_trinkets/client_cam/Stage 2/Client_Screen_2_Positive.png"),
		Enums.CLIENT_CAM_STATE.WORRIED   : preload("res://asset/desk_trinkets/client_cam/Stage 2/Client_Screen_2_Worried.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_1 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_2 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_3 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_4 : null,
	},
	11: {
		Enums.CLIENT_CAM_STATE.OFF       : preload("res://asset/desk_trinkets/client_cam/Client_screen_off.png"),
		Enums.CLIENT_CAM_STATE.BODY      : null,
		Enums.CLIENT_CAM_STATE.HAPPY     : null,
		Enums.CLIENT_CAM_STATE.POSITIVE  : preload("res://asset/desk_trinkets/client_cam/Stage 3/Client_Screen_3_Positive.png"),
		Enums.CLIENT_CAM_STATE.WORRIED   : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_1 : preload("res://asset/desk_trinkets/client_cam/Stage 3/Client_Screen_3_Embarrased.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_2 : preload("res://asset/desk_trinkets/client_cam/Stage 3/Client_Screen_3_Excited_Silly.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_3 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_4 : null,
	},
	# Day 11 evening
	12: {
		Enums.CLIENT_CAM_STATE.OFF       : preload("res://asset/desk_trinkets/client_cam/Client_screen_off.png"),
		Enums.CLIENT_CAM_STATE.BODY      : null,
		Enums.CLIENT_CAM_STATE.HAPPY     : null,
		Enums.CLIENT_CAM_STATE.POSITIVE  : preload("res://asset/desk_trinkets/client_cam/Stage 4/Client_Screen_4_Positive.png"),
		Enums.CLIENT_CAM_STATE.WORRIED   : preload("res://asset/desk_trinkets/client_cam/Stage 4/Client_Screen_4_Nervous.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_1 : preload("res://asset/desk_trinkets/client_cam/Stage 4/Client_Screen_4_Moving.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_2 : preload("res://asset/desk_trinkets/client_cam/Stage 4/Client_Screen_4_Scheming.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_3 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_4 : null,
	},
	13: {
		Enums.CLIENT_CAM_STATE.OFF       : preload("res://asset/desk_trinkets/client_cam/Client_screen_off.png"),
		Enums.CLIENT_CAM_STATE.BODY      : null,
		Enums.CLIENT_CAM_STATE.HAPPY     : preload("res://asset/desk_trinkets/client_cam/Stage 5/Client_Screen_5_Happy.png"),
		Enums.CLIENT_CAM_STATE.POSITIVE  : null,
		Enums.CLIENT_CAM_STATE.WORRIED   : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_1 : preload("res://asset/desk_trinkets/client_cam/Stage 5/Client_Screen_5_Desperate.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_2 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_3 : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_4 : null,
	},
	# Day 13 evening
	14: {
		Enums.CLIENT_CAM_STATE.OFF       : preload("res://asset/desk_trinkets/client_cam/Client_screen_off.png"),
		Enums.CLIENT_CAM_STATE.BODY      : null,
		Enums.CLIENT_CAM_STATE.HAPPY     : null,
		Enums.CLIENT_CAM_STATE.POSITIVE  : null,
		Enums.CLIENT_CAM_STATE.WORRIED   : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_1 : preload("res://asset/desk_trinkets/client_cam/Stage 6/Client_Screen_6_Talking.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_2 : preload("res://asset/desk_trinkets/client_cam/Stage 6/Client_Screen_6_Drinking_Peeking.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_3 : preload("res://asset/desk_trinkets/client_cam/Stage 6/Client_Screen_6_Drinking_Content.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_4 : preload("res://asset/desk_trinkets/client_cam/Stage 6/Client_Screen_6_Breathing.png"),
	},
	15: {
		Enums.CLIENT_CAM_STATE.OFF       : preload("res://asset/desk_trinkets/client_cam/Client_screen_off.png"),
		Enums.CLIENT_CAM_STATE.BODY      : null,
		Enums.CLIENT_CAM_STATE.HAPPY     : null,
		Enums.CLIENT_CAM_STATE.POSITIVE  : null,
		Enums.CLIENT_CAM_STATE.WORRIED   : null,
		Enums.CLIENT_CAM_STATE.SPECIAL_1 : preload("res://asset/desk_trinkets/client_cam/Stage 7/Client_Screen_7_Big.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_2 : preload("res://asset/desk_trinkets/client_cam/Stage 7/Client_Screen_7_Big_Crack_1.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_3 : preload("res://asset/desk_trinkets/client_cam/Stage 7/Client_Screen_7_Big_Crack_2.png"),
		Enums.CLIENT_CAM_STATE.SPECIAL_4 : null,
	}
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.client_cam_state_changed.connect(update_cam_graphic);


func update_cam_graphic(cam_state : Enums.CLIENT_CAM_STATE):
	var day = floori(Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER));
	if not day_to_cam_graphics.has(day) or not day_to_cam_graphics[day].has(cam_state):
		printerr("Failed to find possible graphic for cam state in client cam");
		return;
		
	var graphic = day_to_cam_graphics[day][cam_state];
	if graphic == null:
		printerr("Graphic not assigned for cam state %d and day %d" % [cam_state, day]);
		return;
		
	$ClientFootage.texture = graphic;

	
