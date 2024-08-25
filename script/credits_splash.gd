extends Control

var time_to_wait : float = 3;
var cur_wait_time : float = 0;
var should_end : bool = false;
var is_ending : bool = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true;
	$Fader.lighten(0.5);


func _input(event):
	if event is InputEventKey and event.pressed or event is InputEventMouseButton and event.pressed:
		should_end = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_ending:
		return;
	
	if should_end:
		$Fader.darken(0.5);
		#Utility.load_scene(0.5, Globals.SCENE_MAIN_MENU);
		get_tree().create_timer(0.5).timeout.connect(func (): 
			visible = false
			SignalBus.credit_splash_finished.emit();
			);
		is_ending = true;
		return;
		
	cur_wait_time += delta;
	
	if cur_wait_time >= time_to_wait:
		should_end = true;
