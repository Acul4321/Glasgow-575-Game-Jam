extends Node2D

enum ShipSize {
	Tiny,
	Small,
	Medium,
	Large
}

@export var size: ShipSize = ShipSize.Tiny
@export var build_time: float = 1

func _ready() -> void:
	set_addons([])


# shows ship visuals of addon IDs present in addon list.
func set_addons(enabled_addons: Array[String]) -> void:
	for addon in find_children("*", "CanvasItem", true, false):
		if not addon.is_in_group("ship_addon"):
			continue

		var addon_id := str(addon.get_meta("addon_id", ""))
		addon.set("visible", addon_id in enabled_addons)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
