extends CanvasLayer


@onready var game := Game_Manager
@onready var wave := WaveManager


# Constants
const SHOP_ACC_ROW = preload("uid://br8qdqqge6hgr")

# Nodes
@onready var planet := get_tree().get_first_node_in_group("Planet")

# Labels
@onready var resource_label: Label = $ResourceLabel
@onready var wave_label: Label = $WaveLabel
@onready var bwave_label: Label = $BossWaveLabel
@onready var planet_shield: Label = $PlanetShield

# Buttons
@onready var start_wave_button: Button = $StartWaveButton
@onready var retry_button: Button = $GameOverScreen/VBoxContainer/RetryButton
@onready var restart_button: Button = $RestartButton

# Control Nodes
@onready var game_over_screen: Control = $GameOverScreen
@onready var shop_panel: PanelContainer = $ShopPanel

# Shop Lists
@onready var satellites_list: VBoxContainer = $ShopPanel/VBoxContainer/ShopTabs/Satellites/VBoxContainer
@onready var drones_list: VBoxContainer = $ShopPanel/VBoxContainer/ShopTabs/Drones/VBoxContainer
@onready var planet_list: VBoxContainer = $ShopPanel/VBoxContainer/ShopTabs/Planet/VBoxContainer

var in_shop : bool



func _ready() -> void:
	game.resources_changed.connect(_update_r_ui)				# signals from Game_Manager
	game.shield_changed.connect(_update_shield_ui)			# ^
	game.game_over.connect(game_over_event)					# ^
	
	wave.wave_complete.connect(_shop_ui)						# signal from WaveManager
	
	retry_button.pressed.connect(_on_retry_button_pressed)	# signal from button in ui.tscn
	start_wave_button.pressed.connect(_on_start_wave_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	
	_populate_shop_panel()
	
	# Deferred so these read final values; waits for sibling's _ready() debug settings
	# Refresh ui with current stats upon loading
	_update_r_ui.call_deferred()
	_update_shield_ui.call_deferred()
	_shop_ui.call_deferred()

# Refreshes resource display ui
func _update_r_ui() -> void:
	resource_label.text = "Resources: " + str(game.resources)

# Refreshes Planet shield display ui
func _update_shield_ui() -> void:
	
	# Gets shield value from active_stats Array in Game_Manager
	var current_shield = planet.shield
	planet_shield.text = "Shield: " + str(current_shield)

# Runs reset function in Game_Manager
func _on_retry_button_pressed() -> void:
	game.game_reset()
	# Reload the current active scene to wipe existing asteroids/resources from the field
	get_tree().reload_current_scene()
	
# [DEBUGGING] Restart and reloads game
func _on_restart_button_pressed() -> void:
	print_rich(" [color=yellow][b][DEBUG][/b][/color] Game Manually Reset via 'Restart Game' Button ")
	game.game_reset()
	get_tree().reload_current_scene()

# Starts next wave and hides shop
func _on_start_wave_button_pressed() -> void:
	wave.start_wave()
	_shop_ui()

# Displays "Game Over" screen | Called from Game_Manager
func game_over_event() -> void:
	game_over_screen.visible = true

# Populates the entire shop panel with defenses and upgrades | Called via _ready()
func _populate_shop_panel() -> void:
	for defense in game.all_defenses:
		var list = satellites_list if defense is SatelliteData else drones_list
		_add_row(list, defense)
	
	for upgrade in game.all_upgrades:
		if upgrade.target_category == StatIDs.GLOBAL:
			_add_row(planet_list, upgrade)

# Creates ShopAccordionRow under specified list | Called via _populate_shop_panel()
func _add_row(list: VBoxContainer, data) -> void:
	var row = SHOP_ACC_ROW.instantiate()
	list.add_child(row)
	
	if data is DefenseData:
		row.setup_defense(data)
	elif data is UpgradeData:
		row.setup_upgrade(data)

# Displays and handles shop screen ui
func _shop_ui() -> void:
	
	# Displays Shop and UI info based on if the wave is active
	if wave.wave_active:
		in_shop = false
		shop_panel.hide()
		start_wave_button.hide()
		bwave_label.hide()
		wave_label.text = "Wave: " + str(wave.current_wave)
	else:
		in_shop = true
		shop_panel.show()
		start_wave_button.show()
		wave_label.text = "Next Wave: " + str(wave.current_wave)
		
		# Displays next boss wave if current wave is within 5 waves
		if wave.current_wave + 4 >= wave.next_boss_wave:
			bwave_label.show()
			bwave_label.text = "Upcoming Boss: Wave " + str(wave.next_boss_wave)
		else:
			bwave_label.hide()


func camera_shift() -> void:
	pass
