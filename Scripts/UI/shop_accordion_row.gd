extends FoldableContainer


const PURCHASE_LINE = preload("uid://cp6tj7w5vc06h")

@onready var game := Game_Manager


@onready var desc_label: Label = $PurchaseLines/Description
@onready var purchase_vbox: VBoxContainer = $PurchaseLines


# Used for Satellites and Drones tabs
func setup_defense(data: DefenseData) -> void:
	title = data.display_name
	desc_label.text = data.description
	
	_add_defense_line(data)
	
	for upgrade in game.all_upgrades:
		if upgrade.target_category == data.id:
			_add_upgrade_line(upgrade)

# Used for Planet tab (no parent, just 'global')
func setup_upgrade(data: UpgradeData) -> void:
	title = data.display_name
	desc_label.text = data.description
	
	_add_upgrade_line(data)

# Used to create Perk Tier grouping - temp until tree
func setup_perk_tier(tier: int, perks: Array) -> void:
	title = "Tier %d" % tier
	desc_label.text = ""
	for perk in perks:
		add_perk_line(perk)

# Creates and sets up purchase line for defenses
func _add_defense_line(data: DefenseData) -> void:
	var purchase_line = PURCHASE_LINE.instantiate()
	purchase_vbox.add_child(purchase_line)
	purchase_line.setup_defense(data)

# Creates and sets up purchase line for upgrades
func _add_upgrade_line(data: UpgradeData) -> void:
	var purchase_line = PURCHASE_LINE.instantiate()
	purchase_vbox.add_child(purchase_line)
	purchase_line.setup_upgrade(data)

# Creates and sets up purchase line for perks
func add_perk_line(data: PerkData) -> void:
	var purchase_line = PURCHASE_LINE.instantiate()
	purchase_vbox.add_child(purchase_line)
	purchase_line.setup_perk(data)
