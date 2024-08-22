extends RigidBody2D

var is_hovered_over = false;

var should_teleport : bool = false
var should_launch: bool = false;
var teleport_location : Vector2 = Vector2.ZERO
var launch_velocity: Vector2 = Vector2.ZERO


func _input(event):
	if event is InputEventMouseMotion and is_hovered_over:
		launch_velocity = event.get_velocity() * Vector2(0.5,0.5);		
		print(launch_velocity);
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
			get_tree().create_timer(2.5).timeout.connect(func (): $SFX.play());

func _on_mouse_shape_entered(shape_idx: int) -> void:
	is_hovered_over = true;


func _on_mouse_shape_exited(shape_idx: int) -> void:
	is_hovered_over = false;
