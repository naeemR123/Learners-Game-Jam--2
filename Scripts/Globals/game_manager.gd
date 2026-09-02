extends Node



#  = Arrays - Dictionaries = #

# Game Start Global Defaults
const DEFAULT_GLOBAL_STATS := {
	"slow_strength": 0.0,
	"max_planet_shield": 20.0,
	"beam_size": 50.0,
}

# Holds the CURRENT value of ALL upgradable stats game-wide : populated via register_defense_stats()
var active_stats: Dictionary = { StatIDs.GLOBAL: DEFAULT_GLOBAL_STATS.duplicate() }
var owned_defenses: Array[String] = []			# Stores all active defenses : populated via purchase_defenses()
var all_defenses : Array[DefenseData] = []		# Stores all defenses : populated via register_all_defenses()
var all_upgrades : Array[UpgradeData] = []		# Stores all upgrades : populated via register_all_defenses()
var all_perks : Array[PerkData] = []			# Stores all perks : populated via register_all_perks()

# { category: { stat_id: summed-flat-bonus/combined-multiplier } }
var perk_flat : Dictionary = {}					# Stores active FLAT perk-types : populated via purchase_perk()
var perk_mult : Dictionary = {}					# Stores active PERCENT perk-types : populated via purchase_perk()

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
	register_all_upgrades()		# CRITICAL : ^ Upgrades after defenses
	register_all_perks()		# CRITICAL : ^ Perks after upgrades

# Adds resource to inventory and updates ui
func add_resource(amount: int) -> void:
	resources += amount
	resources_changed.emit()

# Processes damage done to Planet, destroys if 0
func take_damage(damage_val: float) -> void:
	
	# Safety net : Can't take damage if destroyed
	if planet_destroyed: return
	
	# Reduces shield based on damage value
	var planet = get_tree().get_first_node_in_group("Planet")
	
	if planet == null: 
		push_warning(" [GAME] Could not run take_damage() due to planet == null | Game_Manager ")
		return
	
	planet.shield -= damage_val # Deals damage
	
	# Safety correction
	if planet.shield <= 0: planet.shield = 0
	
	# Tells UI to refresh
	shield_changed.emit()
	
	print_rich(" [color=green][b][GAME][/b][/color] Planet hit for %.1f damage | \
	Current Shield: %.1f" % [damage_val,planet.shield])
	
	# If shield is 0, run game over function
	if planet.shield == 0:
		trigger_game_over()

# Scans the Defenses resource folder and registers stats for every DefenseData it finds
func register_all_defenses() -> void:
	_register_folder("res://Scripts/Resources/Defenses/", DefenseData, register_defense_stats, "DEFENSES")

# Scans the Upgrades resource folder and registers stats for every UpgradeData it finds
func register_all_upgrades() -> void:
	_register_folder("res://Scripts/Resources/Upgrades/", UpgradeData, register_upgrade_array, "UPGRADES")

# Scans the Perks resource folder and registers stats for every PerkData it finds
func register_all_perks() -> void:
	_register_folder("res://Scripts/Resources/Perks/", PerkData, register_perk_stats, "PERKS")

# Scans Resources folder for files (by scanning subfolders using _scan_resource_folder()) then hands it to a registrar 
func _register_folder(path: String, expected_type, registrar: Callable, label: String) -> void:
	var paths := _scan_resource_folder(path)
	
	if paths.is_empty():
		push_warning("[color=red][b][ERROR][/b][/color] No resources found under %s | %s registration aborted" % [path, label])
		return
	
	for file_path in paths:
		var resource = load(file_path)
		if is_instance_of(resource, expected_type):
			registrar.call(resource)
		else:
			push_warning("[color=red][b][ERROR][/b][/color] Unexpected resource type in %s folder: %s" % [label, file_path])
		
	print(" | %s REGISTERED | " % label)

# Scans Folder for resource files and returns array of them
func _scan_resource_folder(path: String) -> Array[String]:
	var found: Array[String] = []
	
	for file_name in DirAccess.get_files_at(path):
		if file_name.ends_with(".remap"):
			file_name = file_name.trim_suffix(".remap")
		
		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			found.append(path.path_join(file_name))
		
	for folder_name in DirAccess.get_directories_at(path):
		found.append_array(_scan_resource_folder(path.path_join(folder_name)))
	
	return found

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

# Checks 'all_upgrades' for resource , if not found, references it
# Called by register_all_upgrades()
func register_upgrade_array(upgrade: UpgradeData) -> void:
	
	# Safe for multiple calls : won't overwrite if entry exists
	if not all_upgrades.has(upgrade):
		
		# Syncs base_value with the defense's actual base stat, so the two can't be different
		if active_stats.has(upgrade.target_category) and active_stats[upgrade.target_category].has(upgrade.id):
			upgrade.base_value = active_stats[upgrade.target_category][upgrade.id]
		else:
			push_warning("[color=red][b][ERROR][/b][/color] register_upgrade_array: target_category '%s' or id '%s' not found in active_stats. \
			Check the UpgradeData's fields" % [upgrade.target_category, upgrade.id])
		# References original data in Array
		all_upgrades.append(upgrade)

# Checks arrays for perk , if not found , adds it 
# Called by register_all_perks()
func register_perk_stats(perk: PerkData) -> void:
	# Safety Checks : aborts if already registered or if perk's target category is not found in active_stats
	if all_perks.has(perk): return
	
	if perk.target_category == StatIDs.ALL:
		for category in active_stats:
			if category != StatIDs.GLOBAL and active_stats[category].has(perk.stat_id):
				all_perks.append(perk)
				return
		
		push_warning("[color=red][b][ERROR][/b][/color] register_perk_stats: '%s' targets ALL but no defense has stat '%s'" % [perk.id, perk.stat_id])
		return
	
	if not active_stats.has(perk.target_category): 
		push_warning("[color=red][b][ERROR][/b][/color] Perk not registered correctly | \
		active_stats does not contain '%s' perk's target_category: '%s'" % [perk.id, perk.target_category])
		return
	if not active_stats[perk.target_category].has(perk.stat_id):
		push_warning("[color=red][b][GAME ERROR][/b][/color] register_perk_stats: stat_id '%s' not found in active_stats['%s'] | \
		Check the PerkData's fields" % [perk.stat_id, perk.target_category])
		return
	all_perks.append(perk)

# Returns a stat's value BEFORE any Perks and the upgrade curve if one exists | Defaults otherwise
func get_base_stat(category: String, stat_id: String) -> float:
	for upgrade in all_upgrades:
		if upgrade.target_category == category and upgrade.id == stat_id:
			return upgrade.get_current_value()
	
	if category == StatIDs.GLOBAL:
		return DEFAULT_GLOBAL_STATS.get(stat_id, 0.0)
	
	for defense in all_defenses:
		if defense.id == category:
			return defense.default_stats.get(stat_id, 0.0)
	
	push_warning("get_base_stat: no source found for '%s' / '%s'" % [category, stat_id])
	return 0.0

# Recomputes one stat from its base + every perk after, then writes the result to the stat.
func recalculate_stat(category: String, stat_id: String) -> void:
	var flat: float = perk_flat.get(category, {}).get(stat_id, 0.0)
	var mult: float = perk_mult.get(category, {}).get(stat_id, 1.0)
	
	active_stats[category][stat_id] = (get_base_stat(category, stat_id) + flat) * mult


func _resolve_perk_categories(perk: PerkData) -> Array[String]:
	var categories : Array[String] = []
	
	if perk.target_category == StatIDs.ALL:
		for category in active_stats:
			if category == StatIDs.GLOBAL:
				continue
			if active_stats[category].has(perk.stat_id):
				categories.append(category)
	
	elif active_stats.has(perk.target_category) and active_stats[perk.target_category].has(perk.stat_id):
		categories.append(perk.target_category)
	
	return categories

# Purchase function for Defenses
func purchase_defenses(defense: DefenseData) -> bool:
	
	if defense.get_block_reason() != PurchaseBlock.Reason.NONE:
		return false
	
	# Defines current cost of defense based on its criteria
	var cost = defense.get_current_cost()
	
	# Loads or makes an orbit ring
	var ring = load_orbit_ring(defense)
	if ring == null:	# Safety check
		push_warning(" [color=green][b][GAME][/b][/color] Defense Purchase Unsuccessful | Ring Generation Failed , \
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
	ring.add_child(new_defense)
	ring.redistribute()
	
	resources -= cost
	defense.amount_owned += 1
	defense.is_purchased = true
	
	# Tells UI to refresh
	resources_changed.emit()
	
	print_rich(" [color=green][b][GAME][/b][/color] Defense Purchase Successful | Purchased %s" % defense.id)
	return true # Purchase successful

# Purchase function for Upgrades
func purchase_upgrade(upgrade: UpgradeData) -> bool:
	
	if upgrade.get_block_reason() != PurchaseBlock.Reason.NONE:
		return false
	
	# Safety check : Only upgrades if it is a valid registered category and property
	if active_stats.has(upgrade.target_category):
		# Defines current cost value of upgrade
		var cost = upgrade.get_current_cost()
		resources -= cost
		upgrade.level_up()
		recalculate_stat(upgrade.target_category, upgrade.id)
		
	else:
		# Pushes if upgrade's target_category doesn't exist - meaning the category was never registered, or it is incorrect
		push_warning("Purchase_upgrade: target_category '%s' not found in active_stats. Was it registered correctly?" % upgrade.target_category)
		return false # Purchase unsuccessful : target_category not found in active_stats
	
	# Tells UI to refresh
	resources_changed.emit()
	stats_changed.emit()
	
	return true # Purchase successful

# Purchase function for Perks
func purchase_perk(perk: PerkData) -> bool:
	
	if perk.get_block_reason() != PurchaseBlock.Reason.NONE:
		return false
	
	# Safety check : Only upgrades if it is a valid registered category and property
	var categories := _resolve_perk_categories(perk)
	if categories.is_empty():
		push_warning("[color=red][b][GAME ERROR][/b][/color] purchase_perk: '%s' resolved to no categories for stat '%s'" % [perk.id, perk.stat_id])
		return false
	
	resources -= perk.get_current_cost()
	perk.is_purchased = true
	
	
	for cat in categories:
		var stat := perk.stat_id
		match perk.perk_type:
			PerkData.PerkType.FLAT:
				if not perk_flat.has(cat): perk_flat[cat] = {}
				perk_flat[cat][stat] = perk_flat[cat].get(stat, 0.0) + perk.value
			
			PerkData.PerkType.PERCENT:
				if not perk_mult.has(cat): perk_mult[cat] = {}
				perk_mult[cat][stat] = perk_mult[cat].get(stat,1.0) * (1.0 + perk.value)
		
		recalculate_stat(cat, stat)
	resources_changed.emit()
	stats_changed.emit()
	
	print_rich(" [color=green][b][GAME][/b][/color] Perk Purchase SUCCESSFUL | Purchased '%s'" % perk.id)
	return true

# Bulks purchases defenses | Defaults at 10x
func purchase_defenses_bulk(defense: DefenseData, amount: int = 10) -> int:
	
	var bought : int = 0
	var target : int = amount if amount > 0 else 9999
	
	while bought < target:
		if defense.amount_owned >= defense.max_allowed:	# Safety Check
			break
		if not purchase_defenses(defense):	# Breaks if purchase returns as false
			break
		bought += 1
	
	return bought

# Bulks purchases upgrades | Defaults at 10x
func purchase_upgrade_bulk(upgrade: UpgradeData, amount: int = 10) -> int:
	
	var bought : int = 0
	var target : int = amount if amount > 0 else 9999
	
	while bought < target:
		if not purchase_upgrade(upgrade):	# Already runs internal safety check
			break
		bought += 1
	
	return bought

# Loads a pre-existing orbit ring, or makes a new one if needed | Called via purchase_defenses()
func load_orbit_ring(defense: DefenseData) -> Node2D:
	
	var existing_rings = get_tree().current_scene.get_node("OrbitManager").get_children() # Creates array of OrbitManager's children
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
		correct_ring = _orbit_ring_generator(defense)
	
	return correct_ring

# Loads and returns a newly generated Orbit Ring attached to the OrbitManager | Called via load_orbit_ring()
func _orbit_ring_generator(defense) -> Node2D:
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
	print(" | GAME PAUSED | ")

# Reset function | Connected to "Try Again?" Button on 'Game Over' screen
func game_reset() -> void:
	print(" ~ RESETTING GAME... ~ ")
	
	# Resets values and properties
	resources = 0
	planet_destroyed = false
	print(" | GLOBAL STATE VARIABLES RESET | ")
	
	# Clears active_stats
	active_stats.clear()
	print(" | ACTIVE_STATS ARRAY CLEARED | ")
	
	# Sets global to default values
	var planet = get_tree().get_first_node_in_group("Planet")
	active_stats[StatIDs.GLOBAL] = DEFAULT_GLOBAL_STATS.duplicate()
	print(" | PLANET SHIELD RESET | ")
	print(" | GLOBAL ACTIVE_STATS RESET | ")
	
	# Resets WaveManager
	WaveManager.reset() 	# Resets Wave to 1
	print(" | WAVE MANAGER RESET | ")
	
	# Runs reset() for all current perks,defenses, and upgrades: sets level to 1
	for perk in all_perks:
		perk.reset()
	print(" | PERKS RESET | ")
	for upgrade in all_upgrades:
		upgrade.reset()
	print(" | UPGRADE LEVELS RESET | ")
	for defense in all_defenses:
		defense.reset()
	print(" | DEFENSE LEVELS RESET | ")
	
	# Rebuilds stat library arrays
	all_defenses.clear()
	print(" | ALL_DEFENSES ARRAY CLEARED | ")
	owned_defenses.clear()
	print(" | OWNED_DEFENSES ARRAY CLEARED | ")
	all_upgrades.clear()
	print(" | ALL_UPGRADES ARRAY CLEARED | ")
	all_perks.clear()
	print(" | ALL_PERKS ARRAY CLEARED | ")
	perk_flat.clear()
	print(" | PERKS_FLAT ARRAY CLEARED | ")
	perk_mult.clear()
	print(" | PERKS_MULT ARRAY CLEARED | ")
	register_all_defenses()
	register_all_upgrades()
	register_all_perks()
	
	resources_changed.emit()
	stats_changed.emit()
	
	get_tree().paused = false	# Unpauses game
	print(" | GAME UNPAUSED | ")
	
	print(" ~ GAME RESET COMPLETE ~ ")
