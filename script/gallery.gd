extends Control


func _ready() -> void:
	$CutscenePlayer.finished.connect(func(): $CutscenePlayer.visible = false);
	$CutscenePlayer.visible = false;
	$DisplayItem.visible = false;
	update_button_graphics_by_unlock();

func update_button_graphics_by_unlock():
	var cutscenes_locked : bool = not Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_CUTSCENES);
	var sketches_locked : bool = not Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_SKETCHES);
	var concept_locked : bool = not Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_CONCEPT);

	# Cutscene Group
	$GalleryGrid/GalleryItem_OpeningCutscene.disabled = cutscenes_locked;
	$GalleryGrid/GalleryItem_WallCutscene.disabled = cutscenes_locked;
	
	# Sketch Group
	$GalleryGrid/GalleryItem_Sketch_1.disabled = sketches_locked;
	$GalleryGrid/GalleryItem_Sketch_2.disabled = sketches_locked;
	$GalleryGrid/GalleryItem_Sketch_3.disabled = sketches_locked;
	$GalleryGrid/GalleryItem_Sketch_4.disabled = sketches_locked;
	
	
	# Concept Group
	$GalleryGrid/GalleryItem_concept_1.disabled = concept_locked;
	$GalleryGrid/GalleryItem_concept_2.disabled = concept_locked;
	$GalleryGrid/GalleryItem_concept_3.disabled = concept_locked;
	$GalleryGrid/GalleryItem_concept_4.disabled = concept_locked;
	$GalleryGrid/GalleryItem_concept_5.disabled = concept_locked;
	$GalleryGrid/GalleryItem_concept_6.disabled = concept_locked;
	
	# Special
	var finished_game : bool = Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_FINISHED_GAME, false);
	$GalleryGrid/GalleryItem_FinaleImage.disabled = not finished_game;
	$GalleryGrid/GalleryItem_ClientSequence.disabled = not finished_game;

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
	$DisplayItem.texture = preload("res://asset/gallery/sketches/client_sizes.png");

func _on_gallery_item_sketch_2_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/sketches/miscellany.png");


func _on_gallery_item_sketch_3_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/sketches/poor_wet_cat.png");


func _on_gallery_item_sketch_4_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/sketches/stylesheet.png");

func _on_gallery_item_client_sequence_button_down() -> void:
	$CutscenePlayer.visible = true;
	$CutscenePlayer.stream = preload("res://asset/gallery/client_screen_sequence.ogv");
	$CutscenePlayer.play();


func _on_gallery_item_concept_1_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/concept/characters.png");


func _on_gallery_item_concept_2_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/concept/client_1.png");


func _on_gallery_item_concept_3_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/concept/HR.png");


func _on_gallery_item_concept_4_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/concept/management_shade.png");


func _on_gallery_item_concept_5_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/concept/manager_concept.png");


func _on_gallery_item_concept_6_button_down() -> void:
	$DisplayItem.visible = true;
	$DisplayItem.texture = preload("res://asset/gallery/concept/protagonist.png");
