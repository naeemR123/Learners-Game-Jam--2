extends Node2D


@onready var game := Game_Manager
@onready var wave := WaveManager


@export_category("Debug")
@export var extra_resources: bool = false
@export var extra_amount: int = 100
@export var custom_wave: bool = false
@export var wave_number: int = 1

func _ready() -> void:
	
	if custom_wave:
		wave.current_wave = wave_number
		print("! Custom Wave Debug: ENABLED")
		print(" - Wave set to: %d" % wave.current_wave)
		
	
	if extra_resources:
		game.add_resource(extra_amount)
		print("! Extra Resources Debug: ENABLED")
		print(" - Added %d resources" % extra_amount)
	
	game.add_resource(15)
	
	
