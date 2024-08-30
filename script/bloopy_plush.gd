extends TextureButton


var woomy_sounds = [
	preload("res://asset/desk_trinkets/bloopy_plush/woomy.ogg"),
	preload("res://asset/desk_trinkets/bloopy_plush/veemo.ogg")
]

func _on_button_down() -> void:
	$SFX.stream = woomy_sounds.pick_random();
	$SFX.play();
