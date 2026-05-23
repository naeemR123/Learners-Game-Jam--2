# res://scripts/GameManager.gd
extends Node

var resources = 0

signal resource_changed(amount)

func add_resource(amount):
	resources += amount
	resource_changed.emit(resources)
