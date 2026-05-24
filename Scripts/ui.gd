extends CanvasLayer



@onready var label: Label = $Label


func _ready() -> void:
	Game_Manager.connect("resources_changed", resource_label)



func _process(delta: float) -> void:
	pass


func resource_label(new_amount):
	label.text = "Resources: " + str(new_amount)
