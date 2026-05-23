extends Node2D



@export var orbit_speed : float = 1.0
@export var projectile_scene : PackedScene

@onready var turret_body : Node2D = $Turret
@onready var range : Area2D = $Turret/Range
@onready var muzzle : Marker2D = $Turret/Muzzle
@onready var planet : Area2D = %Planet

func _ready() -> void:
	global_position = planet.global_position


func _process(delta: float) -> void:
	# Rotates the pivot, making the offset Turret orbit
	rotation += orbit_speed * delta
	
	# Sets the nearest asteroid as the target
	var target = get_nearest_asteroid()
	
	if target != null:
		# Makes the turret visually face the target
		turret_body.look_at(target.global_position)
	

func _on_firerate_timeout() -> void:
	# Sets the nearest asteroid as the target
	var target = get_nearest_asteroid()
	
	if target != null:
		shoot(target)

func get_nearest_asteroid() -> Area2D:
	
	# Grab all areas currently inside the Range's collision circle
	var asteroids_in_range = range.get_overlapping_areas()
	
	if asteroids_in_range.is_empty():
		return null
	
	var nearest_asteroid: Area2D = null
	var shortest_distance: float = INF  # INF stands for infinity
	
	# Loops through asteroids and finds which one is closest to the turret
	for asteroid in asteroids_in_range:
		var distance = turret_body.global_position.distance_to(asteroid.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_asteroid = asteroid
	
	
	return nearest_asteroid


func shoot(target: Area2D) -> void:
	if projectile_scene == null:
		return
	
	var proj = projectile_scene.instantiate()
	# Always add projectiles to the main scene so they don't inherit the turret's rotation!
	get_tree().current_scene.add_child(proj)
	
	# Initialize the projectile
	proj.start(muzzle.global_position, target.global_position)
