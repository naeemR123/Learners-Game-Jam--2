# res://scripts/ResourcePickup.gd
extends Area2D

var amount = 1   # How many resources this drop gives
var lifetime = 10.0

func _ready():
	add_to_group("resource")

func collect():
	# Tell the GameManager we've been collected
	GameManager.add_resource(amount)
	queue_free()

func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
