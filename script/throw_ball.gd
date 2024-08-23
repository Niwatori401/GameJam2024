extends RigidBody2D

var is_hovered_over = false;

var should_teleport : bool = false
var should_launch: bool = false;
var teleport_location : Vector2 = Vector2.ZERO
var launch_velocity: Vector2 = Vector2.ZERO
var impact_index : int = 0;

var save = ConfigFile.new();

func _input(event):
	if event is InputEventMouseMotion and is_hovered_over:
		launch_velocity = event.get_velocity() * Vector2(0.5,0.5);		
	var status = save.load(Globals.USER_SAVE_FILE);
	if status != OK:
		printerr("Failed to load save in throw_ball.gd");
	
	impact_index = save.get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_THROWN_BALL_IMPACT_INDEX, 0);


func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_hovered_over:
		should_teleport = true;
	elif Input.is_action_just_released("accept"):
		should_launch = true;


func _integrate_forces(state):
	if should_teleport:
		state.linear_velocity = Vector2(0 ,0);
		state.transform.origin = get_global_mouse_position();
		should_teleport = false;
		
	elif should_launch:
		should_launch = false;
		state.linear_velocity = launch_velocity;
		const GLASS_BREAK_VELOCITY_MAGNITUDE = 2000;
		if sqrt(launch_velocity[0]**2 + launch_velocity[1]**2) >= GLASS_BREAK_VELOCITY_MAGNITUDE:
			get_tree().create_timer(2.5).timeout.connect(func ():
				play_current_sound();
				impact_index += 1;
				save.set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_THROWN_BALL_IMPACT_INDEX, impact_index);
				);


func play_current_sound():
	if impact_index == 0:
		$SFX1.play();
	elif impact_index == 1:
		$"SFX2-1".play();
		get_tree().create_timer(2.0).timeout.connect(func (): $"SFX2-2".play());
	elif impact_index == 2:
		$SFX3.play();

	impact_index += 1;

func _on_mouse_shape_entered(shape_idx: int) -> void:
	is_hovered_over = true;


func _on_mouse_shape_exited(shape_idx: int) -> void:
	is_hovered_over = false;
