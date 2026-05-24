class_name GameManager
extends Node

var resources :int = 0

signal resources_changed(new_amount)


func add_resource(amount: int):
	resources += amount
	resources_changed.emit(resources)
