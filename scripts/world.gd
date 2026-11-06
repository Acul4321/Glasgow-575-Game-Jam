extends Node2D

@onready var ally_base: Base = $Game/Base/AllyBase
@onready var boat_preview: Node2D = get_tree().get_first_node_in_group("boat_preview")

var addon_selectors: Array[Node] = []

@export var boat_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addon_selectors = get_tree().get_nodes_in_group("addon_selector")

	for selector in addon_selectors:
		selector.toggled.connect(_on_addon_toggled)

	_update_boat_preview()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_launch_button_pressed() -> void:
	# builds a boat using every currently selected addon.
	ally_base.build_boat(boat_scene, _get_selected_addons())


# updates the preview
func _on_addon_toggled(_enabled: bool) -> void:
	_update_boat_preview()


# updates the selected addons to the boat preview.
func _update_boat_preview() -> void:
	boat_preview.call("set_addons", _get_selected_addons())


# gets selected addon IDs from checked buttons
func _get_selected_addons() -> Array[String]:
	var selected_addons: Array[String] = []

	for selector in addon_selectors:
		if selector.button_pressed:
			selected_addons.append(str(selector.get_meta("addon_id", "")))

	return selected_addons
