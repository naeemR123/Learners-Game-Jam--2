extends HBoxContainer



const REASON_TEXT := {
	PurchaseBlock.Reason.LOCKED: "Locked!",
	PurchaseBlock.Reason.MAX_OWNED: "Max Amount Owned!",
	PurchaseBlock.Reason.MAX_COST: "Max Cost Reached!",
	PurchaseBlock.Reason.MAX_VALUE: "Max Value Reached!",
	PurchaseBlock.Reason.NOT_ENOUGH_RESOURCES: "Not Enough Resources!",
}


@onready var game := Game_Manager
@onready var orbit_manager := get_tree().current_scene.get_node("OrbitManager")

# - Node References -
@onready var name_label: Label = $Name
@onready var value_label: Label = $Value
@onready var cost_label: Label = $Cost
@onready var purchase_button: Button = $Purchase
@onready var bulk_button: Button = $Bulk

# State Variables | Universal storage
var defense_data : DefenseData
var upgrade_data : UpgradeData


func _ready() -> void:
	# Connects signals and purchase button
	purchase_button.pressed.connect(_on_purchase_pressed)
	bulk_button.pressed.connect(_on_bulk_purchase_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	
	WaveManager.wave_complete.connect(update_display)
	game.resources_changed.connect(update_display)
	game.stats_changed.connect(update_display)

# Stores defense for this purchase line
func setup_defense(data: DefenseData) -> void:
	defense_data = data
	update_display()

# Stores upgrade for this purchase line
func setup_upgrade(data: UpgradeData) -> void:
	upgrade_data = data
	update_display()

# Attempts to purchase based on data source
func _on_purchase_pressed() -> void:
	if defense_data:
		game.purchase_defenses(defense_data)
	elif upgrade_data:
		game.purchase_upgrade(upgrade_data)


func _on_bulk_purchase_pressed() -> void:
	var amount = -1 if Input.is_key_pressed(KEY_SHIFT) else 10
	
	if defense_data:
		game.purchase_defenses_bulk(defense_data, amount)
	elif upgrade_data:
		game.purchase_upgrade_bulk(upgrade_data, amount)


func _process(_delta: float) -> void:
	var new_text = "Max" if Input.is_key_pressed(KEY_SHIFT) else "x10"
	if bulk_button.text != new_text:
		bulk_button.text = new_text


func _on_mouse_entered() -> void:
	if upgrade_data and upgrade_data.id == StatIDs.RANGE:
		var next_range = upgrade_data.get_current_value(upgrade_data.current_level+1)
		_set_satellite_range_visible(true, next_range)


func _on_mouse_exited() -> void:
	if upgrade_data and upgrade_data.id == StatIDs.RANGE:
		_set_satellite_range_visible(false)


func _set_satellite_range_visible(can_see: bool, next_range: float = 0.0) -> void:
	for ring in orbit_manager.get_children():
		if ring.my_id == upgrade_data.target_category:
			var all_sats = ring.get_children()
			
			if not can_see:
				for sat in all_sats:
					sat.range_indicator.visible = false
					if sat.has_method("set_preview_range_visible"):
						sat.set_preview_range_visible(false)
				return
			var rand_sat = all_sats.pick_random()
			if rand_sat.has_method("set_range_visible"):
				rand_sat.set_range_visible(true)
			if rand_sat.has_method("set_preview_range_visible"):
				rand_sat.set_preview_range_visible(true, next_range)
			return

# Refreshes UI
func update_display() -> void:
	if defense_data:
		_update_defense_display()
	elif upgrade_data:
		_update_upgrade_display()

# Refreshes the displayed text and values
func _update_defense_display() -> void:
	# Determines if button should be disabled
	var reason = defense_data.get_block_reason()
	var cost: int = defense_data.get_current_cost()
	var owned: int = defense_data.amount_owned
	# Refreshes text and values
	name_label.text = "Buy " + defense_data.display_name
	value_label.text = ""
	tooltip_text = "%d %s owned" % [owned, defense_data.display_name] 	# Allows desc. to display on mouse hover
	mouse_filter = Control.MOUSE_FILTER_PASS	# Enables mouse hover
	
	if reason == PurchaseBlock.Reason.MAX_OWNED:
		cost_label.text = "MAXED"  
	elif reason == PurchaseBlock.Reason.LOCKED: 
		cost_label.text = "Unlocks Wave %d" % defense_data.unlock_wave 
	else:
		cost_label.text = str(cost) + " resources"
	
	purchase_button.tooltip_text = REASON_TEXT.get(reason, "")
	bulk_button.tooltip_text = purchase_button.tooltip_text
	
	# Disables button if not enough resources or max amount of defenses already owned
	var blocked = reason != PurchaseBlock.Reason.NONE
	purchase_button.disabled = blocked
	bulk_button.disabled = blocked

# Refreshes the displayed text and values
func _update_upgrade_display() -> void:
	var reason = upgrade_data.get_block_reason()
	var cost: int = upgrade_data.get_current_cost()
	var current_val: float = upgrade_data.get_current_value()
	var next_val: float = upgrade_data.get_current_value(upgrade_data.current_level+1)
	# Refreshes text and values
	name_label.text = upgrade_data.display_name
	value_label.text = "%.1f -> %.1f" % [current_val, next_val]
	tooltip_text = "Level: %d\n%s" % [upgrade_data.current_level,upgrade_data.description] 	# Allows desc. to display on mouse hover
	mouse_filter = Control.MOUSE_FILTER_PASS	# Enables mouse hover
	
	var is_maxed = reason == PurchaseBlock.Reason.MAX_COST or reason == PurchaseBlock.Reason.MAX_VALUE
	cost_label.text = "MAXED" if is_maxed else str(cost) + " resources"
	
	purchase_button.tooltip_text = REASON_TEXT.get(reason, "")
	bulk_button.tooltip_text = purchase_button.tooltip_text
	
	var blocked: bool = reason != PurchaseBlock.Reason.NONE
	purchase_button.disabled = blocked	# Disables button if not enough resources
	bulk_button.disabled = blocked
