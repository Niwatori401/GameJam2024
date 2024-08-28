extends RigidBody2D

var is_hovered_over = false;

var should_teleport : bool = false
var should_launch: bool = false;
var teleport_location : Vector2 = Vector2.ZERO
var launch_velocity: Vector2 = Vector2.ZERO
var impact_index : int = 0;

var rubber_ball_texture : Texture2D = preload("res://asset/desk_trinkets/throw_ball/throw_ball_rubber.png");
var baseball_texture : Texture2D = preload("res://asset/desk_trinkets/throw_ball/throw_ball.png");

func _ready() -> void:
	impact_index = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_THROWN_BALL_IMPACT_INDEX, 0);
	update_ball_texture();


func _input(event):
	if event is InputEventMouseMotion and is_hovered_over:
		launch_velocity = event.get_velocity() * Vector2(0.5,0.5);		


func _process(_delta):
	if not is_hovered_over:
		return;
	if impact_index > 2 and Input.is_action_just_pressed("accept"):
		$SFX_Squeak.play();
	if Input.is_action_pressed("accept"):
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
		const GLASS_BREAK_VELOCITY_MAGNITUDE = 1600;
		if sqrt(launch_velocity[0]**2 + launch_velocity[1]**2) >= GLASS_BREAK_VELOCITY_MAGNITUDE:
			get_tree().create_timer(2.0).timeout.connect(func ():
				play_current_sound();
				visible = false;
				impact_index += 1;
				Inventory.get_save().set_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_THROWN_BALL_IMPACT_INDEX, impact_index);
				Inventory.get_save().save(Globals.USER_SAVE_FILE);
				);

func update_ball_texture():
	if impact_index > 2:
		$CollisionShape2D/BallSprite.texture = rubber_ball_texture;
	else:
		$CollisionShape2D/BallSprite.texture = baseball_texture;


func play_current_sound():
	if impact_index == 0:
		$SFX1.play();
	elif impact_index == 1:
		$"SFX2-1".play();
		get_tree().create_timer(1.5).timeout.connect(func (): $"SFX2-2".play());
	elif impact_index == 2:
		$SFX3.play();
	else:
		$SFX_Squeak.volume_db = $SFX_Squeak.volume_db - 20;
		$SFX_Squeak.play();
		$SFX_Squeak.finished.connect(func (): $SFX_Squeak.volume_db = $SFX_Squeak.volume_db + 20);

func _on_mouse_shape_entered(shape_idx: int) -> void:
	is_hovered_over = true;


func _on_mouse_shape_exited(shape_idx: int) -> void:
	is_hovered_over = false;
