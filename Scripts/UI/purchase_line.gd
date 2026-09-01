extends HBoxContainer


@onready var game := Game_Manager

# - Node References -
@onready var name_label: Label = $Name
@onready var value_label: Label = $Value
@onready var cost_label: Label = $Cost
@onready var purchase_button: Button = $Purchase

# State Variables | Universal storage
var defense_data : DefenseData
var upgrade_data : UpgradeData


func _ready() -> void:
	# Connects signals and purchase button
	purchase_button.pressed.connect(_on_purchase_pressed)
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

# Refreshes UI
func update_display() -> void:
	if defense_data:
		_update_defense_display()
	elif upgrade_data:
		_update_upgrade_display()

# Refreshes the displayed text and values
func _update_defense_display() -> void:
	# Determines if button should be disabled
	var is_locked: bool = defense_data.unlock_wave > WaveManager.current_wave
	var cost: int = defense_data.get_current_cost()
	var owned: int = defense_data.amount_owned
	
	name_label.text = "Buy " + defense_data.display_name
	value_label.text = ""
	
	# Locks button if conditions are met
	if is_locked:
		cost_label.text = "Wave %d" % defense_data.unlock_wave
		purchase_button.disabled = true
		return
	
	cost_label.text = str(cost) + " resources"
	# Disables button if not enough resources or max amount of defenses already owned
	purchase_button.disabled = game.resources < cost or owned >= defense_data.max_allowed

# Refreshes the displayed text and values
func _update_upgrade_display() -> void:
	var cost: int = upgrade_data.get_current_cost()
	var current_val: float = upgrade_data.get_current_value()
	var next_val: float = upgrade_data.get_current_value(upgrade_data.current_level+1)
	
	# Refreshes text and values
	name_label.text = upgrade_data.display_name
	tooltip_text = upgrade_data.description 	# Allows desc. to display on mouse hover
	mouse_filter = Control.MOUSE_FILTER_PASS	# Enables mouse hover
	value_label.text = "%.1f -> %.1f" % [current_val, next_val]
	cost_label.text = str(cost) + " resources"
	purchase_button.disabled = game.resources < cost	# Disables button if not enough resources
