extends Node2D

@onready var ally_base: Base = $Game/Base/AllyBase

@export var boat_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_launch_button_pressed() -> void:
	ally_base.build_boat(boat_scene)
