extends Area2D


@onready var game := Game_Manager

@onready var shield_bar : ProgressBar = $ProgressBar

@export var max_shield : float = 20.0

# Variable always synced with Game_Manager's active_stats
var active_max_shield: float:
	get:
		return game.active_stats[StatIDs.GLOBAL][StatIDs.MAX_SHIELD]
	set(value):
		game.active_stats[StatIDs.GLOBAL][StatIDs.MAX_SHIELD] = value

var shield : float = 20.0


func _ready() -> void:
	
	# Tells shield bar to update whenever damage is taken
	game.shield_changed.connect(_update_shield)
	shield_bar.step = 1	# Tells shield bar to move in increments of 1
	
	# Pulls value set for max shield in active_stats
	max_shield = active_max_shield
	shield = active_max_shield
	_update_shield()

# UI & Updates Max shield | Game_Manager handles damage dealth to shield
func _update_shield() -> void:
	
	# Gets max shield value from active_stats Array in Game_Manager
	max_shield = active_max_shield
	shield_bar_update()	# Tells UI to update

# Keeps shield bar UI visually up-to-date
func shield_bar_update() -> void:
	
	shield_bar.max_value = active_max_shield
	shield_bar.value = shield

# Increases shield by amount
func heal(amount: int) -> void:
	shield += amount
	if shield > max_shield:
		shield = max_shield
	
	shield_bar_update()	# Tells UI to update

# Increases max_shield by amount
func increase_max_shield(amount: int) -> void:
	max_shield += amount
	shield += amount
	
	if shield > max_shield:
		shield = max_shield
	
	shield_bar_update()	# Tells UI to update
