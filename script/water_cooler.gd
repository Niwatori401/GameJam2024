extends Control


@export var animation_duration_secs : float = 1;
var secs_per_frame : float;
var shady_sam_opened : bool = false;

var shady_sam_sprites : Array[Texture2D] = [
	preload("res://asset/background/water_cooler/ShadySamPaper/Shady_Sam.png"),
	preload("res://asset/background/water_cooler/ShadySamPaper/Shady_Sam_2.png"),
	preload("res://asset/background/water_cooler/ShadySamPaper/Shady_Sam_3.png"),
]

var shady_sam_hover_sprites : Array[Texture2D] = [
	preload("res://asset/background/water_cooler/ShadySamPaper/shady_sam_hover.png"),
	preload("res://asset/background/water_cooler/ShadySamPaper/shady_sam_hover_3.png")
]

var shady_sam_click_mask_sprites : Array[BitMap] = [
	preload("res://asset/background/water_cooler/ShadySamPaper/shady_sam_button_mask.png"),
	preload("res://asset/background/water_cooler/ShadySamPaper/shady_sam_button_mask_3.png")
]

func _ready():
	$Fader.lighten(0.5);
	secs_per_frame = animation_duration_secs / len(shady_sam_sprites);

func _process(delta: float) -> void:
	if (not $ShadySamButton.has_focus() or not $ShadySamButton.is_hovered()) and shady_sam_opened:
		reverse_animation();


func _on_shady_sam_button_button_down() -> void:
	play_animation();
	
	
func reverse_animation():
	shady_sam_opened = false;
	get_tree().create_timer(1 * secs_per_frame).timeout.connect(func (): 
		$ShadySamButton.texture_normal = shady_sam_sprites[1];
		$ShadySamButton.texture_hover = null;
		);
	get_tree().create_timer(2 * secs_per_frame).timeout.connect(func (): 
		$ShadySamButton.texture_normal = shady_sam_sprites[0];
		$ShadySamButton.texture_hover = shady_sam_hover_sprites[0];
		$ShadySamButton.texture_click_mask = shady_sam_click_mask_sprites[0];
		shady_sam_opened = false);


func play_animation():
	get_tree().create_timer(1 * secs_per_frame).timeout.connect(func (): 
		$ShadySamButton.texture_normal = shady_sam_sprites[1];
		$ShadySamButton.texture_hover = null;
		);
	get_tree().create_timer(2 * secs_per_frame).timeout.connect(func (): 
		$ShadySamButton.texture_normal = shady_sam_sprites[2];
		$ShadySamButton.texture_hover = shady_sam_hover_sprites[1];
		$ShadySamButton.texture_click_mask = shady_sam_click_mask_sprites[1];

		shady_sam_opened = true);


func _on_back_button_button_down() -> void:
	$Fader.darken(0.5);
	Utility.load_scene(0.5, Globals.SCENE_BREAK_ROOM);
