extends Node2D

var cur_seconds : float = 0;
var total_seconds_per_rotation = 60;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cur_seconds += delta;
	if cur_seconds >= total_seconds_per_rotation:
		cur_seconds -= total_seconds_per_rotation;
	$ClockHand.rotation_degrees = 360 * cur_seconds / total_seconds_per_rotation;
	
