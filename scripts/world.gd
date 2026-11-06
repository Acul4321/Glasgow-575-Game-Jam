extends Node2D

@onready var ally_base: Base = $Game/Base/AllyBase
@onready var boat_preview: Node2D = get_tree().get_first_node_in_group("boat_preview")
@onready var boat_price_label: Label = get_tree().get_first_node_in_group("boat_price_display")
@onready var launch_button: Button = get_tree().get_first_node_in_group("launch_button")

var addon_selectors: Array[Node] = []
var addon_price_labels: Array[Node] = []

@export var boat_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addon_selectors = get_tree().get_nodes_in_group("addon_selector")
	addon_price_labels = get_tree().get_nodes_in_group("addon_price_display")

	for selector in addon_selectors:
		selector.toggled.connect(_on_addon_toggled)

	_update_boat_preview()
	_update_addon_price_labels()
	_update_boat_price_label()
	_update_launch_button_price()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_launch_button_pressed() -> void:
	# builds a boat using every currently selected addon.
	ally_base.build_boat(boat_scene, _get_selected_addons())


# updates the preview
func _on_addon_toggled(_enabled: bool) -> void:
	_update_boat_preview()
	_update_addon_price_labels()
	_update_launch_button_price()


# updates the selected addons to the boat preview.
func _update_boat_preview() -> void:
	boat_preview.call("set_addons", _get_selected_addons())


# updates addon prices from the metadata
func _update_addon_price_labels() -> void:
	for price_label in addon_price_labels:
		var addon_id := str(price_label.get_meta("addon_id", ""))
		price_label.text = "$%d" % _get_addon_cost(addon_id)


# Updates the boat price label from the boat scene's exported cost.
func _update_boat_price_label() -> void:
	var boat := boat_scene.instantiate()
	boat_price_label.text = "$%d" % int(boat.get("cost"))
	boat.free()


# Updates the launch button with the current boat configuration cost.
func _update_launch_button_price() -> void:
	launch_button.text = "$%d \n Launch" % _get_configuration_cost()


# calculates the boat configuration cost
func _get_configuration_cost() -> int:
	var boat := boat_scene.instantiate()
	var total_cost := int(boat.call("get_configuration_cost", _get_selected_addons()))
	boat.free()
	return total_cost


# reads an addon's cost metadata
func _get_addon_cost(addon_id: String) -> int:
	var boat := boat_scene.instantiate()
	var cost := int(boat.call("get_addon_cost", addon_id))
	boat.free()
	return cost
	
	
# gets selected addon IDs from checked buttons
func _get_selected_addons() -> Array[String]:
	var selected_addons: Array[String] = []

	for selector in addon_selectors:
		if selector.button_pressed:
			selected_addons.append(str(selector.get_meta("addon_id", "")))

	return selected_addons
