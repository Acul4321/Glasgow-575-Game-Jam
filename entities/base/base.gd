class_name Base
extends Node2D

signal destroyed
signal boat_built

@export var max_health: int = 500
@export var build_time: float = 2.0
@export var build_progress_bar: ProgressBar

@export var is_player_base: bool = true
@export var boat_parent: Node2D
@export var spawn_point: Marker2D

var health: int
var is_building := false


func _ready() -> void:
	health = max_health

func take_damage(amount: int) -> void:
	if health <= 0:
		return

	health -= amount
	health = max(health, 0)

	if health == 0:
		destroy_base()

# spawns a boat after applying addon IDs.
func build_boat(boat_scene: PackedScene, addons: Array[String] = []) -> void:
	if is_building:
		return

	if boat_scene == null:
		push_error("No boat scene assigned to the base.")
		return

	var total_cost := _get_boat_cost(boat_scene, addons)
	if is_player_base and not MoneyManager.spend_money(total_cost):
		return

	is_building = true

	# creates timer to build boat and then displays it on the progress bar
	var build_timer := get_tree().create_timer(build_time)
	if build_progress_bar:
		build_progress_bar.value = 0.0

	while build_timer.time_left > 0.0:
		if build_progress_bar:
			var progress := 1.0 - (build_timer.time_left / build_time)
			build_progress_bar.value = progress * build_progress_bar.max_value
		await get_tree().process_frame

	if build_progress_bar:
		build_progress_bar.value = build_progress_bar.max_value

	var boat := boat_scene.instantiate()

	if boat_parent:
		boat_parent.add_child(boat)
	else:
		get_parent().add_child(boat)

	if spawn_point:
		boat.global_position = spawn_point.global_position
	else:
		boat.global_position = global_position

	boat.set("player_ship", is_player_base)
	boat.call("set_addons", addons)

	is_building = false
	boat_built.emit()


# Calculates the boat cost plus the costs of its selected addon visuals.
func _get_boat_cost(boat_scene: PackedScene, addons: Array[String]) -> int:
	var cost_preview := boat_scene.instantiate()
	var total_cost := int(cost_preview.get("cost"))

	for addon in cost_preview.find_children("*", "CanvasItem", true, false):
		if not addon.is_in_group("ship_addon"):
			continue

		var addon_id := str(addon.get_meta("addon_id", ""))
		if addon_id in addons:
			total_cost += int(addon.get_meta("cost", 0))

	cost_preview.free()
	return total_cost


func destroy_base() -> void:
	destroyed.emit()
	queue_free()
