extends Node2D


@onready var game := Game_Manager


func _ready() -> void:
	game.add_resource(15)
