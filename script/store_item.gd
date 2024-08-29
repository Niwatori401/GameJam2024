extends TextureButton



@export var cost : int = 0;
@export var description : String = "Lorem Ipsum Set Dolor Amet";
@export var item_name : String = "Holy Hand Grenade";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Inventory.get_money_amount() < cost:
		disabled = true;

func get_item_name() -> String:
	return item_name;

func get_description() -> String:
	return description;



func _on_focus_entered() -> void:
	if disabled:
		return;
	SignalBus.store_item_selected.emit(item_name, description, cost);
	print("_on_focus_entered")


func _on_mouse_entered() -> void:
	if disabled:
		return;
	SignalBus.store_item_selected.emit(item_name, description, cost);
	print("_on_mouse_entered")

func _on_focus_exited() -> void:
	SignalBus.no_item_selected.emit();
	print("_on_focus_exited")

func _on_mouse_exited() -> void:
	SignalBus.no_item_selected.emit();
	print("_on_mouse_exited")
