extends TextureButton

@export var button_description_text := "A button";


func _on_focus_entered() -> void:
	SignalBus.button_selected.emit(button_description_text);


func _on_mouse_entered() -> void:
	SignalBus.button_selected.emit(button_description_text);


func _on_focus_exited() -> void:
	SignalBus.button_exited.emit(button_description_text);


func _on_mouse_exited() -> void:
	SignalBus.button_exited.emit(button_description_text);
