class_name BoatResource
extends Resource

@export var boat_name: String
@export var behavior_script: Script

@export var size: BaseShip.ShipSize = BaseShip.ShipSize.Tiny
@export var build_time: float = 1.0
@export var cost: int = 20
@export var available_addons: Array[String] = []
