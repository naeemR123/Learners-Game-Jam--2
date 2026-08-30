extends Resource
class_name UpgradeData


enum ScalingType { ADDITIVE, MULTIPLICATIVE, SUBTRACTIVE } 

#############################
# -= PROPERTY ASSIGNMENT =- #
#############################

@export var id: String = "e.g. 'fire_rate'" 							# A unique name used by Game_Manager (e.g. fire_rate)
@export var display_name: String = "e.g. 'Turret Satelitte Fire Rate'"	# The name displayed for players
@export var target_category: String = "e.g. 'turret_satellite'"			# Tells the game WHERE to apply this upgrade
@export_multiline var description: String = "What this upgrade does..."

@export_category("Economy")
@export var base_cost: int = 1
@export var max_cost: int = 0 # 0 == no max
@export var cost_multiplier: float = 1.00


@export_category("Effect")
@export var base_value: float	# !!! Exported value in Inspector MAY not do anything : Auto-syncs with target_category's base stat
@export var max_value: float	# 0 == no max
@export var val_per_level: float
@export var scaling_type: ScalingType = ScalingType.ADDITIVE	# Determines whether base_value is increased using a formula that adds or multiplies

# State variables (Not exported; dynamic during gameplay)
var current_level: int = 1




#################
# - Functions - #
#################


func get_current_cost(level: float = current_level) -> int:
	
	var current_cost = int(base_cost * pow(cost_multiplier, level - 1))
	
	# If no max_cost set, then it skips
	if max_cost > 0 and max_cost <= current_cost:
		return max_cost
	
	return current_cost


func get_current_value(level: float = current_level) -> float:
	
	# Uses matching formula to selected scaling_type then uses val_up_per_level as the value increase
	match scaling_type:
		
		ScalingType.ADDITIVE:
			
			var current_value = base_value + (val_per_level * (level - 1))
			if max_value > 0 and max_value <= current_value:
				return max_value
			return current_value
		
		ScalingType.MULTIPLICATIVE:
			
			var current_value = base_value * pow(val_per_level, level - 1)
			if max_value > 0 and max_value <= current_value:
				return max_value
			return current_value
		
		ScalingType.SUBTRACTIVE:
			
			var current_value = base_value - (val_per_level * (level - 1))
			if max_value > 0 and max_value >= current_value:
				return max_value
			return current_value
		
		# If no acceptable scaling_type selected, pushes warning and returns base_value
		_:
			push_warning("Unknown scaling_type on UpgradeData: %s" % id)
			return base_value


func level_up() -> void:
	current_level += 1


func reset() -> void:
	current_level = 1
	
