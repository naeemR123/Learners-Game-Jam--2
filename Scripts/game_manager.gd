extends Node

var resources :int = 0
@export var turret_fire_rate: float = 2.0
var turret_upgrade_cost: int = 10
var turret_upgrade_level: int = 1

@export var slow_down_amount: float = 0.75
var tractor_upgrade_cost: int = 10
var tractor_upgrade_level: int = 1

signal turret_upgrade(new_amount)
signal resources_changed()


func add_resource(amount: int):
	resources += amount
	resources_changed.emit()


func update_firerate(amount: float):
	turret_fire_rate -= amount
	if turret_fire_rate < 0.05:
		turret_fire_rate = 0.05
	turret_upgrade.emit(turret_fire_rate)
