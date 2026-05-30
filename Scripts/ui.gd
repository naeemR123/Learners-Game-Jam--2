extends CanvasLayer


@onready var game := Game_Manager
@onready var wave := WaveManager


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



func _ready() -> void:
	game.resources_changed.connect(update_r_ui)				# signals from Game_Manager
	game.shield_changed.connect(update_shield_ui)			# ^
	game.game_over.connect(game_over_event)					# ^
	game_over_screen.visible = false						# ^
	
	wave.wave_complete.connect(shop_ui)						# signal from WaveManager
	
	retry_button.pressed.connect(_on_retry_button_pressed)	# signal from button in ui.tscn
	start_wave_button.pressed.connect(_on_start_wave_button_pressed)
	
	# Refresh ui with current stats upon loading
	update_w_ui()
	update_r_ui()
	update_shield_ui()

# Refreshes resource display ui
func update_r_ui():
	rlabel.text = "Resources: " + str(game.resources)


# Refreshes wave display ui
func update_w_ui():
	wlabel.text = "Wave: " + str(wave.current_wave)


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
	update_w_ui()
	
	
	if wave.wave_active:
		shop_container.hide()
	else:
		shop_container.show()
