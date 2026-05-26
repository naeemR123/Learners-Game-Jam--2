extends Node

var resources :int = 0
var planet_destroyed : bool = false

var owned_defenses: Array[String] = []

var max_planet_shield: float = 10.0

# This Dictionary holds the CURRENT value of all upgrade stats
# Turrets and Tractor beams will read from this dictionary using the exact "id" string.
var active_stats: Dictionary = {
	"global": {
			"slow_down_amount": 0.75,
			"planet_shield": 10.0,
			"orbit_speed": 1.0,
			"orbit_distance" : 100.0,
	},
	"turret_satellite": {
			"fire_rate": 2.0,
			"damage": 3.0,
	},
	"laser_satellite": {
			"fire_rate": 2.0,
			"damage": 3.0,
	},
	"missile_satellite": {
			"fire_rate": 2.0,
			"damage": 3.0,
	},
}




# Signals
signal stats_changed()
signal resources_changed()
signal shield_changed()
signal game_over()



#################
# - Functions - #
#################


func add_resource(amount: int):
	resources += amount
	resources_changed.emit()

func purchase_defenses(defense: DefenseData) -> bool:		# Purchase function for Defenses

	var cost = defense.get_current_cost()
	
	if resources >= cost and defense.amount_owned < defense.max_allowed:
		resources -= cost
		defense.amount_owned += 1
		defense.is_unlocked = true
		
		owned_defenses.append(defense.id)
		
		var new_defense = defense.defense_scene.instantiate()
		if new_defense.has_method("initialize"):
			new_defense.initialize(defense)
		
		get_tree().current_scene.add_child(new_defense)
		
		resources_changed.emit()
		return true # Purchase successful
	return false # Purchase unsuccessful : not enough resources or max amount owned


func purchase_upgrade(upgrade: UpgradeData) -> bool:		# Purchase function for Upgrades

	var cost = upgrade.get_current_cost()
	
	if resources >= cost:
		resources -= cost
		upgrade.level_up()
		
		# Update the dictionary using the UpgradeData's ID
		if active_stats.has(upgrade.target_category):
			active_stats[upgrade.target_category][upgrade.id] = upgrade.get_current_value()
		
		
		resources_changed.emit()
		stats_changed.emit()
		return true # Purchase successful
	return false # Purchase unsuccessful : not enough resources


func take_damage(damage_val: float):
	if planet_destroyed:
		return
	
	active_stats["global"]["planet_shield"] -= damage_val
	if active_stats["global"]["planet_shield"] < 0:
		active_stats["global"]["planet_shield"] = 0
	
	shield_changed.emit()
	
	if active_stats["global"]["planet_shield"] == 0:
		trigger_game_over()


func trigger_game_over():
	planet_destroyed = true
	game_over.emit()
	get_tree().paused = true


# Reset function for "Try Again?" Button
func game_reset():
	resources = 0
	planet_destroyed = false
	owned_defenses.clear()
	
	active_stats["global"]["slow_down_amount"] = 0.75
	active_stats["global"]["planet_shield"] = max_planet_shield
	active_stats["global"]["orbit_speed"] = 1.0
	active_stats["global"]["orbit_distance"] = 100.0
	active_stats["turret_satellite"]["fire_rate"] = 2.0
	active_stats["laser_satellite"]["fire_rate"] = 2.0
	active_stats["missile_satellite"]["fire_rate"] = 2.0
	
	
	get_tree().paused = false
	
	
