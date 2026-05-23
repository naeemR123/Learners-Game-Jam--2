extends Area2D


@export var max_speed : float = 40
@export var min_speed : float = 15
var speed : float = randf_range(min_speed,max_speed)
var direction : Vector2

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
	# Produces movement
	global_position += direction * speed * delta


func _on_area_entered(body: Area2D) -> void:
	if body != planet:
		return
	else:
		queue_free()
		print("Planet hit")
