extends Area2D


@onready var game := Game_Manager

@onready var shield_bar : ProgressBar = $ProgressBar

@export var shield : float = 20.0
@export var max_shield : float = 20.0


func _ready() -> void:
	
	game.shield_changed.connect(_update_shield_ui)
	shield_bar.step = 1
	
	game.active_stats[StatIDs.GLOBAL][StatIDs.MAX_SHIELD] = max_shield
	shield = max_shield
	_update_shield_ui.call_deferred()

func _update_shield_ui() -> void:
	
	#print("[DEBUG] update_shield function fired.")
	
	# Gets shield value from active_stats Array in Game_Manager
	max_shield = game.active_stats[StatIDs.GLOBAL][StatIDs.MAX_SHIELD]
	shield_bar.min_value = 0
	shield_bar.max_value = max_shield
	shield_bar.value = shield
	
	#print("[DEBUG] current_shield reads: %d, shield_bar.value reads: %d" % [current_shield, shield_bar.value])
