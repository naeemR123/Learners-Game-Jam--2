extends Node

var resources :int = 0

# Turret Upgrades
@export var turret_fire_rate: float = 2.0
var turret_upgrade_cost: int = 10
var turret_upgrade_level: int = 1

# Tractor Beam Upgrades
@export var slow_down_amount: float = 0.75
var tractor_upgrade_cost: int = 10
var tractor_upgrade_level: int = 1

# Planet Defense Upgrades
@export var max_planet_defense: int = 10
var current_planet_defense: int = 10
var defense_upgrade_cost: int = 10
var defense_upgrade_level: int = 1
var planet_destroyed : bool = false

# Signals
signal turret_upgrade(new_amount)
signal resources_changed()
signal defense_changed()
signal game_over()

#################
# - Functions - #
#################

func add_resource(amount: int):
	resources += amount
	resources_changed.emit()


func update_firerate(amount: float):
	turret_fire_rate -= amount
	if turret_fire_rate < 0.05:
		turret_fire_rate = 0.05
	turret_upgrade.emit(turret_fire_rate)


func take_damage(damage_val: int):
	if planet_destroyed:
		return
	
	current_planet_defense -= damage_val
	if current_planet_defense < 0:
		current_planet_defense = 0
	
	defense_changed.emit()
	
	if current_planet_defense <= 0:
		trigger_game_over()


func trigger_game_over():
	planet_destroyed = true
	game_over.emit()
	get_tree().paused = true


# Reset function for "Try Again?" Button
func game_reset():
	resources = 0
	turret_fire_rate = 2.0
	turret_upgrade_cost = 10
	turret_upgrade_level = 1
	slow_down_amount = 0.75
	tractor_upgrade_cost = 10
	tractor_upgrade_level = 1
	
	current_planet_defense = max_planet_defense
	planet_destroyed = false
	get_tree().paused = false
	
	
