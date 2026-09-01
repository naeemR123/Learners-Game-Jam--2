extends Resource
class_name PerkData


@export var id : String
@export var display_name : String
@export_multiline var description : String = "What this perk does..."

@export_category("Economy")
@export var cost : int

@export_category("Effect")
## Mirror [code]UpgradeData[/code]: which [code]active_stats[/code] category this affects
@export var target_category : String
## Which [code]stat/key[/code] within the specified [code]target_category[/code]
@export var stat_id : String			
## Flat, one-time [code]value[/code] of effect- no levels or scaling
@export var value : float				

@export_category("Tree")
@export var prerequisites : Array[PerkData] = []	# Must ALL be purchased before this becomes purchasable
@export var tier : int = 0		# Vertical row hint for future tree layout

var is_purchased : bool = false


# Determines if this perk should be unlocked based on if it's prerequisites are
func is_unlocked() -> bool:
	for perk in prerequisites:
		if not perk.is_purchased:
			return false
	return true

func reset() -> void:
	is_purchased = false
