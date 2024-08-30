extends Control


func _ready() -> void:
	$CutscenePlayer.finished.connect(func(): $CutscenePlayer.visible = false);

	update_button_graphics_by_unlock();

func update_button_graphics_by_unlock():
	var cutscenes_locked : bool = Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_CUTSCENES);
	var sketches_locked : bool = Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_SKETCHES);
	var concept_locked : bool = Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_CONCEPT);

	# Cutscene Group
	$GalleryGrid/GalleryItem_OpeningCutscene.disabled = cutscenes_locked;
	$GalleryGrid/GalleryItem_WallCutscene.disabled = cutscenes_locked;
	$GalleryGrid/GalleryItem_EndingScene.disabled = cutscenes_locked;
	
	# Sketch Group
	$GalleryGrid/GalleryItem_Sketch_1.disabled = sketches_locked;
	$GalleryGrid/GalleryItem_Sketch_2.disabled = sketches_locked;
	
	
	# Concept Group
	$GalleryGrid/GalleryItem_concept_1.disabled = concept_locked;
	$GalleryGrid/GalleryItem_concept_2.disabled = concept_locked;
	
	
	# Special
	$GalleryGrid/GalleryItem_FinaleImage.disabled = not Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_FINISHED_GAME, false);


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		$CutscenePlayer.visible = false;
		$CutscenePlayer.stop();
		$DisplayItem.visible = false;


func _on_gallery_item_opening_cutscene_button_down() -> void:
	$CutscenePlayer.visible = true;
	$CutscenePlayer.stream = preload("res://asset/gallery/opening_cutscene.ogv");
	$CutscenePlayer.play();


func _on_gallery_item_sketch_1_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/pepper.png");


func _on_gallery_item_client_sequence_button_down() -> void:
	$CutscenePlayer.visible = true;
	$CutscenePlayer.stream = preload("res://asset/gallery/client_screen_sequence.ogv");
	$CutscenePlayer.play();
