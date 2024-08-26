extends Control

const FADE_IN_TIME : float = 3;
const GAME_OVER_FADE_IN_TIME = 2;
var can_skip := false;
var is_skipping := false;

var should_fade_in_game_over := false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fader.lighten(FADE_IN_TIME);
	$GameOverScreen.modulate.a = 0;
	$ButtonControls.modulate.a = 0;
	get_tree().create_timer(FADE_IN_TIME).timeout.connect(func(): should_fade_in_game_over = true)

func _process(delta: float) -> void:
	if should_fade_in_game_over and $GameOverScreen.modulate.a < 1:
		if 1 - $GameOverScreen.modulate.a <= delta / GAME_OVER_FADE_IN_TIME:
			$GameOverScreen.modulate.a = 1;
			can_skip = true;
			return;
			
		$GameOverScreen.modulate.a += delta / GAME_OVER_FADE_IN_TIME;
		
	if can_skip and not is_skipping:
		$ButtonControls.modulate.a = 1;

		if Input.is_action_just_pressed("accept"):
			is_skipping = true;
			Utility.load_scene(2, Globals.SCENE_PRE_MAIN_GAME);
			$Fader.darken(2);
		if Input.is_action_just_pressed("escape"):
			is_skipping = true;
			Utility.load_scene(2, Globals.SCENE_MAIN_MENU);
			$Fader.darken(2);
