extends Node2D

@export var bullet_scene : PackedScene
@export var fire_rate := 1.0

var target : Node2D = null
var enemies_in_range = []

@onready var fire_timer = $FireTimer

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_detection_radius_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
