extends RichTextLabel


func _ready() -> void:
	SignalBus.button_selected.connect(func(button_description_text): text = "[center](%s)[/center]" % [button_description_text]);
	SignalBus.button_exited.connect(func(button_description_text): text = "");
