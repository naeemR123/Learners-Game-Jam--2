extends Polygon2D


@export_category("Tween Settings")
@export var max_alpha : float = 1.0
@export var min_alpha : float = 0.25
@export var duration : float = .12
@export var blinks : int = 2


var blink_tween : Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func blink() -> void:
	if blink_tween and blink_tween.is_valid(): blink_tween.kill()
	blink_tween = create_tween()
	blink_tween.set_loops(blinks)
	blink_tween.tween_property(self, "modulate:a", max_alpha, duration)
	blink_tween.tween_property(self, "modulate:a", min_alpha, duration)
