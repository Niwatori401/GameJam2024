extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BGM.fade_in(2);
	$NextKeyIndicator.set_next_key(Enums.NEXT_KEY.UP);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
