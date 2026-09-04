extends Resource
class_name PerkData


enum PerkEffect { STAT_MODIFIER, UNLOCK }
enum PerkType { FLAT, PERCENT }

@export var id : String
@export var display_name : String
@export_multiline var description : String = "What this perk does..."

@export_category("Economy")
@export var cost : int

@export_category("Effect")
## Sets [code]PerkEffect[/code] which determines which kind of perk this is. 
## [code]STAT_MODIFIER[/code] indicates this perk will modify an [code]active_stats[/code] value by a certain amount. These [code]PerkEffects[/code] uses [code]@export[/code] values: [code]target_category, stat_id, and value[/code].
## [code]UNLOCK[/code] indicates this perk will unlock a feature or something similar, and will not effect any stat or value. For example, unlocking extra targeting modes for satellites.
@export var perk_effect : PerkEffect = PerkEffect.STAT_MODIFIER
## Only affected by [code]PerkEffect[/code] [code]UNLOCK[/code].  What to unlock when perk is purchased.
@export var unlock_id : String 
## Only affected by [code]PerkEffect[/code] [code]STAT_MODIFIER[/code].  Mirror [code]UpgradeData[/code]: which [code]active_stats[/code] category this affects
@export var target_category : String
## Only affected by [code]PerkEffect[/code] [code]STAT_MODIFIER[/code].  Which [code]stat/key[/code] within the specified [code]target_category[/code]
@export var stat_id : String
## Only affected by [code]PerkEffect[/code] [code]STAT_MODIFIER[/code].  Sets [code]PerkType[/code] which affects how [code]value[/code] treats desired [code]stat[/code]. Flat for [code]FLAT[/code] (25 == +25), or fraction for [code]PERCENT[/code] (0.25 == +25%)
@export var perk_type : PerkType = PerkType.PERCENT
## Only affected by [code]PerkEffect[/code] [code]STAT_MODIFIER[/code].  One-time [code]value[/code] of effect - no levels or scaling, permanent increase for entire run (until [code]game_reset()[/code]. 
## Flat amount for [code]FLAT[/code] (25 == +25), or a fraction for [code]PERCENT[/code] (0.25 == +25%). 
@export var value : float

@export_category("Tree")
@export var prerequisites : Array[PerkData] = []	# Must ALL be purchased before this becomes purchasable
@export var tier : int = 0		# Vertical row hint for future tree layout

var is_purchased : bool = false


# - Functions - 

# Determines if this perk should be unlocked based on if it's prerequisites are
func _prereqs_met() -> bool:
	for perk in prerequisites:
		if not perk.is_purchased:
			return false
	return true

func reset() -> void:
	is_purchased = false

func get_current_cost() -> int:
	return cost

func get_block_reason(resources: int = Game_Manager.resources) -> PurchaseBlock.Reason:
	if is_purchased:
		return PurchaseBlock.Reason.ALREADY_OWNED
	
	if not _prereqs_met():
		return PurchaseBlock.Reason.PREREQS_NOT_MET
	
	if resources < cost:
		return PurchaseBlock.Reason.NOT_ENOUGH_RESOURCES
	
	return PurchaseBlock.Reason.NONE
