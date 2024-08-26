extends TextureProgressBar

var seconds_to_fall : float = 50;

var total_points_to_apply : float = 0;
var max_points_per_application : float = 1;

var game_over := false;
var game_win := false;

const POINTS_FOR_KEY_HIT : float = 5;
const POINTS_FOR_KEY_FAIL : float = -5;

func _on_game_win() -> void:
	game_win = true;

func _ready() -> void:
	SignalBus.key_miss.connect(lose_points);
	SignalBus.key_hit.connect(gain_points);
	SignalBus.game_win.connect(_on_game_win);

func _process(delta: float) -> void:
	if game_over or game_win:
		return;
		
	do_basic_fall_amount(delta);
	
	if total_points_to_apply == 0:
		return;
	
	do_gained_change_amount(delta);


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
	if abs(total_points_to_apply) >= max_points_per_application:
		amount_to_apply = sign(total_points_to_apply) * max_points_per_application;
		total_points_to_apply -= amount_to_apply;
	else:
		amount_to_apply = total_points_to_apply;
		total_points_to_apply = 0;
		
		
	if value + amount_to_apply > 100:
		value = 100;
		return;
	elif value + amount_to_apply < 0:
		value = 0;
		game_over = true;
		SignalBus.game_loss.emit();
		return;
	
	value += amount_to_apply;
	

func lose_points() -> void:
	total_points_to_apply += POINTS_FOR_KEY_FAIL;

func gain_points() -> void:
	total_points_to_apply += POINTS_FOR_KEY_HIT;
