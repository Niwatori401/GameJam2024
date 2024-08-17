extends Node2D

@export var progress_circle_radius : float = 30;
@export var background_color : Color;
@export var foreground_color : Color;
@export var disabled_color : Color;


const ANGLE_PER_POINT_RAD : float = deg_to_rad(2);
const CIRCLE_ANGLE_OFFSET : float = deg_to_rad(270);
var progress_circle_points := PackedVector2Array();

var current_points : float;
var max_points : float;



func _ready() -> void:
	init_background_progress_bar_points();
	$ProgressPolygonBackground.color = background_color;
	$ProgressPolygonForeground.color = foreground_color;
	current_points = 0;
	max_points = 1;


func _process(delta: float) -> void:
	pass
	#current_points += delta;
	#
	#if current_points > max_points:
		#current_points -= max_points;
#
	#set_progress_to_next_row(current_points / max_points)

func set_show_disabled_overlay(shouldBeVisible: bool):
	$ProgressPolygonDisabledShader.visible = shouldBeVisible;

func init_background_progress_bar_points():
	var points = PackedVector2Array();
	points.append(Vector2(0,0));
	for i in range(floor((1.02 * 2 * PI) / ANGLE_PER_POINT_RAD)):
		var angle = i * ANGLE_PER_POINT_RAD;
		var x_pos = cos(angle + CIRCLE_ANGLE_OFFSET) * progress_circle_radius;
		var y_pos = sin(angle + CIRCLE_ANGLE_OFFSET) * progress_circle_radius;	
		points.append(Vector2(x_pos, y_pos));
		
	$ProgressPolygonBackground.polygon = points;
	$ProgressPolygonDisabledShader.polygon = points;
	
func set_progress_to_next_row(percent):
	# Makes the circle animation look smoother, as it completes the circle before resetting
	percent += 0.02;
	
	var point_count = floor((percent * 2 * PI) / ANGLE_PER_POINT_RAD);
	
	if progress_circle_points.size() - 1 > point_count:
		var old_color = $ProgressPolygonForeground.color;
		$ProgressPolygonForeground.color = $ProgressPolygonBackground.color;
		$ProgressPolygonBackground.color = old_color;
		progress_circle_points.clear();
		percent = 0;
	
	if progress_circle_points.size() == 0:
		progress_circle_points.append(Vector2(0,0));
	
	# Subtract one to account for center point
	var current_point_count = progress_circle_points.size() - 1;
	
	for i in range(point_count - current_point_count):
		var angle = (current_point_count + i) * ANGLE_PER_POINT_RAD;
		var x_pos = cos(angle + CIRCLE_ANGLE_OFFSET) * progress_circle_radius;
		var y_pos = sin(angle + CIRCLE_ANGLE_OFFSET) * progress_circle_radius;	
		progress_circle_points.append(Vector2(x_pos, y_pos));
	
	$ProgressPolygonForeground.polygon = progress_circle_points;
