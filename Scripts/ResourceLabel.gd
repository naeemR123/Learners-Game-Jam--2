# res://scripts/ResourceLabel.gd
extends Label

func _ready():
	GameManager.resource_changed.connect(_update_text)

func _update_text(amount):
	text = "Resources: %d" % amount
