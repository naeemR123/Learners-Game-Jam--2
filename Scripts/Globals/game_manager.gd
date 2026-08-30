extends Node



#  = Arrays - Dictionaries = #

# Holds the CURRENT value of ALL upgradable stats game-wide : populated via register_defense_stats()
var active_stats: Dictionary = {
	"global": {
			"slow_down_amount": 1.0,
			"max_planet_shield": 20,
	},
}
var owned_defenses: Array[String] = []			# Stores all active defenses : populated via purchase_defenses()
var all_defenses : Array[DefenseData] = []		# Stores all defenses : populated via register_all_defenses()
var all_upgrades : Array[UpgradeData] = []		# Stores all upgrades : populated via register_upgrade_array()

# =

# Universal Game Properties
var resources : int = 0
var planet_destroyed : bool = false


# Signals
signal stats_changed()
signal resources_changed()
signal shield_changed()
signal game_over()


#################
# - Functions - #
#################


func _ready() -> void:
	register_all_defenses()		# CRITICAL : needs to run on game startup
	register_all_upgrades()		# CRITICAL : ^


# Adds resource to inventory and updates ui
func add_resource(amount: int) -> void:
	resources += amount
	resources_changed.emit()


# Processes damage done to Planet, destroys if 0
func take_damage(damage_val: float) -> void:
	
	# Safety net : Can't take damage if destroyed
	if planet_destroyed:
		return
		
	# Reduces shield based on damage value
	var planet = get_tree().get_first_node_in_group("Planet")
	
	if planet == null: 
		push_warning(" [GAME] Could not run take_damage() due to planet == null | Game_Manager ")
		return
	
	planet.shield -= damage_val
	
	# Safety correction
	if planet.shield <= 0:
		planet.shield = 0
	
	# Tells UI to refresh
	shield_changed.emit()
	
	print_rich(" [color=green][b][GAME][/b][/color] Planet hit for %.1f damage | Current Shield: %.1f" % [damage_val,planet.shield])
	
	# If shield is 0, run game over function
	if planet.shield == 0:
		trigger_game_over()


# Scans the Defenses folder and registers stats for every DefenseData it finds
func register_all_defenses() -> void:
	
	# Routes access to Defenses Resource folder, and returns if there is no folder
	var dir = DirAccess.open("res://Scripts/Resources/Defenses/")
	
	# Safety check : If folder unavailable, aborts with warning
	if dir == null:
		push_error("Could not open Defenses resource folder")
		return
	
	dir.list_dir_begin() # Start iterating over folder contents
	var file_name = dir.get_next()
	
	# Loops while there are non-blank files
	while file_name != "":
		# Only processes .tres files, skipping other file types
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			# Creates a file path with the specific resource file
			var path = "res://Scripts/Resources/Defenses/" + file_name
			var resource = load(path)	# Loads that path
			
			# Safety check: makes sure it is a DefenseData Resource
			if resource is DefenseData:
				register_defense_stats(resource)	# Upon success, runs function to register it
			else:
				push_warning("Unexpected resource type in Defenses folder: " + path)
			
		file_name = dir.get_next()	# Moves to next file
	
	dir.list_dir_end()	# CRITICAL : always needs to be called when done iterating
	
	print(" | DEFENSES REGISTERED | ")


# Checks arrays for defense , if not found, adds or duplicates it under it's id
# Called by register_all_defenses()
func register_defense_stats(defense: DefenseData) -> void:
	
	# Safe for multiple calls : won't write if entry exists
	if not active_stats.has(defense.id):
		# Duplicates to store an independant copy, instead of referencing the original
		active_stats[defense.id] = defense.default_stats.duplicate()
		
	# Safe for multiple calls : won't write if entry exists
	if not all_defenses.has(defense):
		all_defenses.append(defense)


# Scans the Upgrades folder and registers stats for every UpgradeData it finds
# ~Identical to register_all_defenses() - All comments apply
func register_all_upgrades() -> void:
	
	var dir = DirAccess.open("res://Scripts/Resources/Upgrades/")
	if dir == null:
		push_error("Could not open Upgrades resource folder")
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var path = "res://Scripts/Resources/Upgrades/" + file_name
			var resource = load(path)
			
			if resource is UpgradeData:
				register_upgrade_array(resource)
			else:
				push_warning("Unexpected resource type in Upgrades folder: " + path)
			
		file_name = dir.get_next()
	
	dir.list_dir_end()	# CRITICAL 
	print(" | UPGRADES REGISTERED | ")

# Checks 'all_upgrades' for resource , if not found, references it
# Called by register_all_upgrades()
func register_upgrade_array(upgrade: UpgradeData) -> void:
	
	# Safe for multiple calls : won't overwrite if entry exists
	if not all_upgrades.has(upgrade):
		
		# Syncs base_value with the defense's actual base stat, so the two can't be different
		if active_stats.has(upgrade.target_category) and active_stats[upgrade.target_category].has(upgrade.id):
			upgrade.base_value = active_stats[upgrade.target_category][upgrade.id]
		else:
			push_warning("register_upgrade_array: target_category '%s' or id '%s' not found in active_stats. Check the UpgradeData's fields" % [upgrade.target_category, upgrade.id])
		# References original data in Array
		all_upgrades.append(upgrade)


# Purchase function for Defenses
func purchase_defenses(defense: DefenseData) -> bool:
	
	# Defines current cost of defense based on its criteria
	var cost = defense.get_current_cost()
	
	# Purchases Defense if player has enough resources and space
	if resources >= cost and defense.amount_owned < defense.max_allowed:
		
		# - Generation of Orbit Rings (if necessary) -
		var existing_rings = get_tree().current_scene.get_node("OrbitManager").get_children()	# Creates array of OrbitManager's children
		var duplicate_ring : bool = false
		var correct_ring : Node2D = null	# If nothing assigns it will push error
		
		# If the id matches the incoming defense's id, then the generation 
		# of a new ring is aborted and assigns that ring as the correct_ring
		for ring in existing_rings: # Checks each existing ring's id
			if ring.my_id == defense.id: 
				duplicate_ring = true
				correct_ring = ring
				break
		# Creates new ring if it doesn't already exist
		if not duplicate_ring: 
			correct_ring = generate_orbit_ring(defense)
		
		# Safety check
		if correct_ring == null:
			push_warning(" [GAME] Defense Purchase Unsuccessful | Ring Generation Failed , \
			'correct_ring' returns null value | Attempted to Purchase %s" % defense.id)
			return false
		# -
		# Adds defense.id to 'owned_defenses' Array
		owned_defenses.append(defense.id)
		
		# Register stats the first time it is purchased
		register_defense_stats(defense)
		
		# Instantiates the Defense and runs its initialize function
		var new_defense = defense.defense_scene.instantiate()
		if new_defense.has_method("initialize"):
			new_defense.initialize(defense)
		
		# Adds Defense to scene tree under dedicated Orbit Ring
		correct_ring.add_child(new_defense)
		correct_ring.redistribute()
		
		resources -= cost
		defense.amount_owned += 1
		defense.is_purchased = true
		
		# Tells UI to refresh
		resources_changed.emit()
		
		print_rich(" [color=green][b][GAME][/b][/color] Defense Purchase Successful | Purchased %s" % defense.id)
		return true # Purchase successful
	print_rich(" [color=green][b][GAME][/b][/color] Defense Purchase [u]Unsuccessful[/u] | Attempted to Purchase %s" % defense.id)
	return false # Purchase unsuccessful : not enough resources or max amount owned


# Purchase function for Upgrades
func purchase_upgrade(upgrade: UpgradeData) -> bool:
	
	# Defines current cost of upgrade based on its criteria
	var cost = upgrade.get_current_cost()
	var next_level_cost = upgrade.get_current_cost(upgrade.current_level+1)
	
	if upgrade.max_cost > 0 and cost == upgrade.max_cost:
		push_warning(" [GAME] Purchase_upgrade: UNSUCCESSFUL | Max cost reached: target_category '%s',\
		 with current cost of %d, next cost of %d, and max cost of %d " % \
		[upgrade.target_category, cost, next_level_cost, upgrade.max_value])
		return false
		
	# Purchases if player has enough resources
	if resources >= cost:
		
		# Safety check : Only upgrades if it is a valid, registered category and property
		if active_stats.has(upgrade.target_category):
			var current_value = upgrade.get_current_value()
			var next_level_value = upgrade.get_current_value(upgrade.current_level+1)
			
			if  upgrade.max_value > 0 and upgrade.max_value == current_value:
				push_warning(" [GAME] Puchase_upgrade: UNSUCCESSFUL | Max Upgrade Value reached: target_category '%s', \
				with current value of %.1f, next value of %.1f, and max value of %.1f " % \
				[upgrade.target_category, next_level_value, upgrade.current_level, upgrade.max_value])
				return false
			
			resources -= cost
			upgrade.level_up()	# Increases Upgrade level
			
			# Updates the dictionary using the UpgradeData's ID
			# Upgrades the specified category and property of the targeted Defense
			active_stats[upgrade.target_category][upgrade.id] = current_value
			
		else:
			# Pushes if upgrade's target_category doesn't exist - meaning the category was never registered, or it is incorrect
			push_warning("Purchase_upgrade: target_category '%s' not found in active_stats. Was it registered correctly?" % upgrade.target_category)
			return false # Purchase unsuccessful : target_category not found in active_stats
		
		
		# Tells UI to refresh
		resources_changed.emit()
		stats_changed.emit()
		
		
		print_rich(" [color=green][b][GAME][/b][/color] Upgrade Purchase Successful | Purchased %s at level %d" % [upgrade.id, upgrade.current_level])
		return true # Purchase successful
	print_rich(" [color=green][b][GAME][/b][/color] Upgrade Purchase [u]Unsuccessful[/u] | Attempted to Purchase %s at level %d" % [upgrade.id, upgrade.current_level])
	return false # Purchase unsuccessful : not enough resources


func generate_orbit_ring(defense) -> Node2D:
	var ring_scene = load("uid://d3a75aybwxj44")
	var new_ring = ring_scene.instantiate()
	if new_ring.has_method("initialize"):
		new_ring.initialize(defense)
		get_tree().current_scene.get_node("OrbitManager").add_child(new_ring)
		return new_ring
	else:
		push_error("[ERROR] Could not run 'initialize' on new orbit_ring -- \
		function does not exist in node | Origin: Game_Manager/func purchase_defenses")
		new_ring.queue_free()
		return null

# Game over function
func trigger_game_over() -> void:
	print(" ~ GAME OVER ~ ")
	planet_destroyed = true
	game_over.emit()			# Tells UI to display 'Game Over' screen
	get_tree().paused = true	# Pauses game
	


# Reset function | Connected to "Try Again?" Button on 'Game Over' screen
func game_reset() -> void:
	
	print(" ~ RESETTING GAME... ~ ")
	
	# Resets values and properties
	resources = 0
	planet_destroyed = false
	owned_defenses.clear()
	print(" | GLOBAL STATE VARIABLES RESET | ")
	
	# Sets everything to default values
	var planet = get_tree().get_first_node_in_group("Planet")
	
	active_stats[StatIDs.GLOBAL][StatIDs.SLOW_DOWN_AMOUNT] = 1.00
	active_stats[StatIDs.GLOBAL][StatIDs.MAX_SHIELD] = planet.max_shield
	print(" | GLOBAL ACTIVE_STATS RESET | ")
	
	WaveManager.reset() 	# Resets Wave to 1
	
	# Runs reset() for all current upgrades : sets upgrade level to 1
	for upgrade in all_upgrades:
		upgrade.reset()
	print(" | UPGRADE LEVELS RESET | ")
	
	for defense in all_defenses:
		defense.reset()
	print(" | DEFENSE LEVELS RESET | ")
	
	# Clears all data from Array, except 'global'
	for key in active_stats.keys():
		if key != StatIDs.GLOBAL:
			active_stats.erase(key)
	
	print(" | ACTIVE_STAT ARRAY RESET | ")
	
	# Rebuilds stat library arrays
	register_all_defenses()
	register_all_upgrades()
	
	get_tree().paused = false	# Unpauses game
	
	print(" ~ GAME RESET COMPLETE ~ ")
