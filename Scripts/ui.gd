extends CanvasLayer


@onready var game := Game_Manager
@onready var wave := WaveManager


# Constants
const DEFENSE_BUTTON = preload("res://Scenes/defenses_button.tscn")
const UPGRADE_BUTTON = preload("res://Scenes/upgrade_button.tscn")

# Labels
@onready var rlabel: Label = $ResourceLabel
@onready var wlabel: Label = $WaveLabel
@onready var planet_shield: Label = $PlanetShield

# Buttons
@onready var start_wave_button: Button = $ShopContainer/StartWaveButton
@onready var retry_button: Button = $GameOverScreen/VBoxContainer/RetryButton

# Control Nodes
@onready var game_over_screen: Control = $GameOverScreen
@onready var shop_container: Control = $ShopContainer

# Shop Lists
@onready var defenses_list: VBoxContainer = $ShopContainer/DefensesPanel/ScrollContainer/VBoxContainer/DefensesList
@onready var upgrades_list: VBoxContainer = $ShopContainer/UpgradesPanel/ScrollContainer/VBoxContainer/UpgradesList



func _ready() -> void:
	game.resources_changed.connect(update_r_ui)				# signals from Game_Manager
	game.shield_changed.connect(update_shield_ui)			# ^
	game.game_over.connect(game_over_event)					# ^
	
	wave.wave_complete.connect(shop_ui)						# signal from WaveManager
	
	retry_button.pressed.connect(_on_retry_button_pressed)	# signal from button in ui.tscn
	start_wave_button.pressed.connect(_on_start_wave_button_pressed)
	
	# Refresh ui with current stats upon loading
	update_r_ui()
	update_shield_ui()
	shop_ui()

# Refreshes resource display ui
func update_r_ui():
	rlabel.text = "Resources: " + str(game.resources)


# Refreshes Planet shield display ui
func update_shield_ui():
	
	# Gets shield value from active_stats Array in Game_Manager
	var current_shield = game.active_stats["global"]["planet_shield"]
	planet_shield.text = "shield:\n- " + str(current_shield) + " -"


# Runs reset function in Game_Manager
func _on_retry_button_pressed():
	game.game_reset()
	# Reload the current active scene to wipe existing asteroids/resources from the field
	get_tree().reload_current_scene()


func _on_start_wave_button_pressed():
	wave.start_wave()
	shop_ui()
	


# Displays "Game Over" screen | Called from Game_Manager
func game_over_event():
	game_over_screen.visible = true


# Displays and handles shop screen ui
func shop_ui() -> void:
	
	
	# Displays Shop and UI info based on if the wave is active
	if wave.wave_active:
		shop_container.hide()
		wlabel.text = "Wave: " + str(wave.current_wave)
	else:
		shop_container.show()
		wlabel.text = "Next Wave: " + str(wave.current_wave)
		
		# Deletes any existing buttons in the Shop lists
		for child in defenses_list.get_children():
			child.queue_free()
		
		for child in upgrades_list.get_children():
			child.queue_free()
		
		
		for defense in game.all_defenses:
			var button = DEFENSE_BUTTON.instantiate()
			button.defense_data = defense
			defenses_list.add_child(button)
			
		for upgrade in game.all_upgrades:
			var button = UPGRADE_BUTTON.instantiate()
			button.upgrade_data = upgrade
			upgrades_list.add_child(button)
			
		
		
		
