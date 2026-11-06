extends BaseShip
class_name LandingCraft


func _ready() -> void:
	super._ready()


# Landing craft behavior can be added here without changing other boat types.
func boat_behavior(_delta: float) -> void:
	pass