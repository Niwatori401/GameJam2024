extends AnimatedSprite2D



func _on_animation_finished() -> void:
	$ButtonWithLabel.modulate.a = 1;


func _on_button_with_label_button_down() -> void:
	$ButtonWithLabel.modulate.a = 0;
	play("bobble");
