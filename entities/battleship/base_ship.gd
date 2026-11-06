extends Node2D
class_name BaseShip

enum ShipSize {
	Tiny,
	Small,
	Medium,
	Large
}

@export var size: ShipSize = ShipSize.Tiny
@export var build_time: float = 1
@export var cost: int = 20
@export var available_addons: Array[String] = []
@export var boat_resource: BoatResource

func _ready() -> void:
	_apply_boat_resource()
	set_addons([])

func _apply_boat_resource() -> void:
	if boat_resource == null:
		return

	size = boat_resource.size
	build_time = boat_resource.build_time
	cost = boat_resource.cost
	available_addons = boat_resource.available_addons.duplicate()


# applies selected addons
func set_addons(enabled_addons: Array[String]) -> void:
	for addon in find_children("*", "CanvasItem", true, false):
		if not addon.is_in_group("ship_addon"):
			continue

		var addon_id := str(addon.get_meta("addon_id", ""))
		addon.set("visible", addon_id in enabled_addons and supports_addon(addon_id))


# returns whether this boat type supports addon
func supports_addon(addon_id: String) -> bool:
	return available_addons.is_empty() or addon_id in available_addons


# returns the cost of the boat and all addons
func get_configuration_cost(enabled_addons: Array[String]) -> int:
	var total_cost := cost

	for addon_id in enabled_addons:
		if supports_addon(addon_id):
			total_cost += get_addon_cost(addon_id)

	return total_cost


# gets addon cost from the visual node with the matching addon ID.
func get_addon_cost(addon_id: String) -> int:
	for addon in find_children("*", "CanvasItem", true, false):
		if addon.get_meta("addon_id", "") == addon_id:
			return int(addon.get_meta("cost", 0))

	return 0


#
# override this in a boat subclass for different boat behaviors
#
func boat_behavior(_delta: float) -> void:
	pass


# called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	boat_behavior(delta)
