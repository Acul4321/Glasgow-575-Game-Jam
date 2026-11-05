class_name Base
extends Node2D

signal destroyed
signal boat_built

@export var max_health: int = 500
@export var build_time: float = 2.0

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

func build_boat(boat_scene: PackedScene) -> void:
	if is_building:
		return

	if boat_scene == null:
		push_error("No boat scene assigned to the base.")
		return

	is_building = true

	await get_tree().create_timer(build_time).timeout

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

	is_building = false
	boat_built.emit()


func destroy_base() -> void:
	destroyed.emit()
	queue_free()
