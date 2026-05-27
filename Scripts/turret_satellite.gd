extends Node2D

@onready var game := Game_Manager


@export var projectile_scene : PackedScene = preload("res://Scenes/projectile.tscn")


@onready var turret_body : Node2D = $Turret
@onready var sensor : Area2D = $Turret/Range
@onready var muzzle : Marker2D = $Turret/Muzzle
@onready var planet : Area2D = %Planet
@onready var firerate: Timer = $Turret/Firerate


var my_turn_speed : float = 10
var my_orbit_distance : float = 100
var my_orbit_speed : float = 1
var my_id : String


func initialize(data: SatelliteData):	# Runs right after instantiation, driven by GameManager
	my_id = data.id
	my_orbit_distance = randf_range(data.min_orbit_distance, data.max_orbit_distance)
	my_orbit_speed = randf_range(data.min_orbit_speed, data.max_orbit_speed)
	my_turn_speed = data.turn_speed
	
	# Randomizes starting angle so they don't all spawn at the exact same spot
	rotation = randf_range(0, TAU)		# TAU is 360 degrees in radians


func _ready() -> void:
	global_position = planet.global_position
	
	turret_body.position.x = my_orbit_distance
	
	game.stats_changed.connect(update_turret_stats)
	update_turret_stats()


func update_turret_stats():
	firerate.wait_time = game.active_stats[my_id][StatIDs.FIRE_RATE]


func _process(delta: float) -> void:
	# Rotates the pivot, making the offset Turret orbit
	rotation += my_orbit_speed * delta
	
	# Sets the nearest asteroid as the target
	var target = get_nearest_asteroid()
	if target != null:
		# Makes the turret visually face the target
		var target_angle = turret_body.global_position.direction_to(target.global_position).angle()
		turret_body.global_rotation = lerp_angle(turret_body.global_rotation, target_angle, my_turn_speed * delta)


func _on_firerate_timeout() -> void:
	# Sets the nearest asteroid as the target
	var target = get_nearest_asteroid()
	if target != null:
		shoot(target)


func get_nearest_asteroid() -> Area2D:
	
	# Grab all areas currently inside the Range's collision circle
	var asteroids_in_range = sensor.get_overlapping_areas()
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
	if projectile_scene == null: return
	
	var proj = projectile_scene.instantiate()
	# CRITICAL Adds projectiles to the main scene so they don't inherit the turret's rotation
	get_tree().current_scene.add_child(proj)
	
	# Initialize the projectile
	proj.start(muzzle.global_position, target.global_position, game.active_stats[my_id][StatIDs.DAMAGE])
