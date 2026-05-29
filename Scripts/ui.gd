extends CanvasLayer

@onready var game := Game_Manager
@onready var wave := WaveManager


@onready var label: Label = $Stats
@onready var planet_shield: Label = $PlanetShield
@onready var game_over_screen: Control = $GameOverScreen
@onready var retry_button: Button = $GameOverScreen/VBoxContainer/RetryButton


func _ready() -> void:
	game.resources_changed.connect(update_ui)				# signals from Game_Manager
	game.shield_changed.connect(update_shield_ui)			# ^
	game.game_over.connect(game_over_event)					# ^
	game_over_screen.visible = false						# ^
	
	wave.wave_complete.connect(shop_ui)						# signal from WaveManager
	
	retry_button.pressed.connect(_on_retry_button_pressed)	# signal from game over screen button (Game_Manager)
	
	# Refresh ui with current stats upon loading
	update_ui()
	update_shield_ui()

# Refreshes resource display ui
func update_ui():
	label.text = "Resources: " + str(game.resources)


# Refreshes Planet shield display ui
func update_shield_ui():
	
	# Gets shield value from active_stats Array in Game_Manager
	var current_shield = game.active_stats["global"]["planet_shield"]
	planet_shield.text = "shield:\n-" + str(current_shield) + " -"


# Runs reset function in Game_Manager
func _on_retry_button_pressed():
	game.game_reset()
	# Reload the current active scene to wipe existing asteroids/resources from the field
	get_tree().reload_current_scene()


# Displays "Game Over" screen | Called from Game_Manager
func game_over_event():
	game_over_screen.visible = true


# Displays and handles shop screen ui
func shop_ui() -> void:
	pass	# Add logic for shop ui | Hide and show depending if wave is active
