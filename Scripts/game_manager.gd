extends Node

var resources :int = 0
var planet_destroyed : bool = false

# This Dictionary holds the CURRENT value of all upgrade stats
# Turrets and Tractor beams will read from this dictionary using the exact "id" string.
var active_stats: Dictionary = {
	"turret_fire_rate": 2.0,
	"turret_damage": 3.0,
	"slow_down_amount": 0.75,
	"planet_defense": 10.0,
}

var max_planet_defense: float = 10.0


# Signals
signal stats_changed()
signal resources_changed()
signal game_over()



#################
# - Functions - #
#################


func add_resource(amount: int):
	resources += amount
	resources_changed.emit()


func purchase_upgrade(upgrade: UpgradeData) -> bool:
	var cost = upgrade.get_current_cost()
	
	if resources >= cost:
		resources -= cost
		upgrade.level_up()
		
		# Update the dictionary using the UpgradeData's ID
		active_stats[upgrade.id] = upgrade.get_current_value()
		
		resources_changed.emit()
		return true # Purchase successful
	return false # Purchase unsuccessful : not enough resources


func take_damage(damage_val: float):
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
	
	active_stats[turret_fire_rate] = 2.0
	turret_fire_rate_upgrade_cost = 10
	turret_fire_rate_upgrade_level = 1
	slow_down_amount = 0.75
	tractor_upgrade_cost = 10
	tractor_upgrade_level = 1
	
	current_planet_defense = max_planet_defense
	planet_destroyed = false
	get_tree().paused = false
	
	
