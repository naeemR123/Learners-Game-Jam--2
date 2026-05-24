extends Node

var resources :int = 0
@export var turret_fire_rate: float = 2.0
var turret_upgrade_cost: int = 10
var turret_upgrade_level: int = 1

@export var slow_down_amount: float = 0.75


signal turret_upgrade(new_amount)
signal resources_changed(new_amount)


func add_resource(amount: int):
	resources += amount
	resources_changed.emit(resources)


func update_firerate(amount: float):
	turret_fire_rate -= amount
	turret_upgrade.emit(turret_fire_rate)
