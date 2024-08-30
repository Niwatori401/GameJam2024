extends TextureProgressBar

#ambient drop. 50 means a drop of 2/sec
var seconds_to_fall : float = 50;

var total_points_to_apply : float = 0;
var target_loss_per_second : float = 100;

var game_over := false;
var game_win := false;

@export var face_graphics : Array[Texture2D];
# if above this percent, show that index
var face_graphic_threshold_percentage : Array[float] = [ 85, 60, 40, -100000 ];

var point_gain_loss_by_day = {
	1: [-8, 20],
	2: [-13, 15],
	3: [-13, 15],
	4: [-18, 15],
	5: [-18, 15],
	6: [-23, 10],
	7: [-28, 10],
	8: [-28, 10],
	9: [-28, 10],
	10: [-28, 10],
	11: [-28, 10],
	12: [-28, 10],
	13: [-28, 10],
	14: [-28, 10],
}

func _on_game_win() -> void:
	game_win = true;


var day_number : int;
func _ready() -> void:
	day_number = floori(Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_DAY_NUMBER));
	SignalBus.key_challenge_fail.connect(lose_points);
	SignalBus.key_hit.connect(gain_points);
	SignalBus.game_win.connect(_on_game_win);

func _process(delta: float) -> void:
	if game_over or game_win:
		return;
		
	do_basic_fall_amount(delta);
	
	if total_points_to_apply == 0:
		return;
	
	do_gained_change_amount(delta);
	update_bar_graphic();

var last_index = 0;
func update_bar_graphic():
	for threshold_index in range(len(face_graphic_threshold_percentage)):
		if value >= face_graphic_threshold_percentage[threshold_index]:
			if last_index == threshold_index:
				return;
				
			texture_over = face_graphics[threshold_index];
			last_index = threshold_index;
			return;



func do_basic_fall_amount(delta : float) -> void:
	var base_fall_amount : float = 100 * delta / seconds_to_fall;
	if value <= base_fall_amount:
		value = 0;
		game_over = true;
		SignalBus.game_loss.emit();
	else:
		value -= base_fall_amount;


func do_gained_change_amount(delta : float) -> void:
	var amount_to_apply : float;
	if abs(total_points_to_apply) >= delta * target_loss_per_second:
		amount_to_apply = sign(total_points_to_apply) * delta * target_loss_per_second;
		total_points_to_apply -= amount_to_apply;
	else:
		amount_to_apply = total_points_to_apply;
		total_points_to_apply = 0;
		
		
	if value + amount_to_apply > 100:
		amount_to_apply = 0;
		value = 100;
		return;
	elif value + amount_to_apply < 0:
		value = 0;
		game_over = true;
		SignalBus.game_loss.emit();
		return;
	
	value += amount_to_apply;

func get_gain_points_for_day():
	return point_gain_loss_by_day[day_number][1];

func get_loss_points_for_day():
	return point_gain_loss_by_day[day_number][0];

func lose_points() -> void:
	total_points_to_apply += get_loss_points_for_day();

func gain_points() -> void:
	total_points_to_apply += get_gain_points_for_day();
