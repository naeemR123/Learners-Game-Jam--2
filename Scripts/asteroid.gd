extends Area2D

@onready var game := Game_Manager

@export var data : AsteroidData

@export var resource_max : int = 3
@export var resource_min : int = 1

@export var damage : int = 3

var local_time_scale : float = 1.0

@export var max_speed : float = 40
@export var min_speed : float = 15
@export var rotation_speed : float = randf_range(-0.8,0.8)
var speed : float = randf_range(min_speed,max_speed)
var direction : Vector2

@onready var sprite : Sprite2D = $Sprite2D
@onready var resource_scene : PackedScene = preload("res://Scenes/resource.tscn")

var planet: Area2D 

func start(target_planet: Area2D, start_pos: Vector2, debug_speed: bool, debug_speed_value: float) -> void:
	if debug_speed == true:
		speed = debug_speed_value
	planet = target_planet
	global_position = start_pos
	area_entered.connect(_on_area_entered)
	
	# Sets direciton of Asteroid towards the Planet
	if planet:
		direction = (planet.global_position - global_position).normalized()
	print("Spawned at: ", global_position, " | Speed: ", speed)	# Displays current Asteroid's pos and speed


func _physics_process(delta: float) -> void:
	# Produces movement and rotation
	global_position += direction * speed * local_time_scale * delta
	rotation += rotation_speed * local_time_scale * delta


func _on_area_entered(body: Area2D) -> void:
	if body != planet:
		return
	else:
		game.take_damage(damage)
		queue_free()
		print("Planet hit")


func die():
	var randamount = randi_range(resource_min, resource_max)
	
	for i in randamount:
		var resource = resource_scene.instantiate()
		resource.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", resource)
		
	queue_free()
