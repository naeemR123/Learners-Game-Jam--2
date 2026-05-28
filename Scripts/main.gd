extends Node2D


@onready var game := Game_Manager

@export var turret : SatelliteData
@export var collector : SatelliteData


func _ready() -> void:
	game.resources = 1000
	game.purchase_defenses(turret)
	game.purchase_defenses(collector)
