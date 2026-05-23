extends Area2D


var amount = 1 # How many resources this drop gives
var lifetime = 10.0

func _ready() -> void:
	add_to_group("resource")


func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()


func collect():
	# Tells the GameManager it's been collected
	GameManager.add_resource(amount)
	queue_free()
	
