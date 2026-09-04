extends Marker2D


const ASTEROID_SCENE : PackedScene = preload("uid://dy1a5mdt6iqir")

@onready var wave := WaveManager


@onready var spawntimer: Timer = $SpawnCooldown
@onready var planet : Area2D = get_tree().get_first_node_in_group("Planet")

@export_category("Spawn Adjustments")
@export var radius: float = 2120 # pixels

var custom_asteroid_speed : bool
var custom_asteroid_speed_value : float
var damage_number_toggle : bool



func _ready() -> void:
	wave.timer_interval.connect(timer_info)		# connects from WaveManager

# Recieves spawn interval from WaveManager and starts timer
func timer_info(interval : float) -> void:
	await get_tree().create_timer(3.0).timeout
	spawn_asteroid(wave.get_next_asteroid())
	spawntimer.start(interval)

# Runs get_next_asteroid() from WaveManager, then spawns that random type if eligible
func _on_spawn_cooldown_timeout() -> void:
	
	# Recieves a random asteroid type based on wave + asteroid type criteria
	var type = WaveManager.get_next_asteroid()
	
	# Will recieve null if max asteroids have been spawned, stops spawning if so
	if type == null:
		spawntimer.stop()
		return
	
	spawn_asteroid(type)

# Spawns asteroid in a random location off screen, then 
# passes asteroid type along and runs its start function
func spawn_asteroid(asteroid_type: AsteroidData) -> void:
	
	# Safety net : If no scene loaded then aborts with warning
	if ASTEROID_SCENE == null: 
		push_warning("Cannot spawn Asteroid: No scene loaded (from: asteroid_spawner/spawn_asteroid)")
		return
	
	var angle = randf() * TAU	# Generates random float between 0-1 * 2PI
	var spawn_position : Vector2 = planet.global_position + Vector2.from_angle(angle) * radius
	
	# Instance the asteroid scene
	var asteroid = ASTEROID_SCENE.instantiate()
	
	# CRITICAL : Add to the main scene, NOT the Marker2D spawner.
	# This prevents the asteroid from inheriting the spawner's transform.
	get_tree().current_scene.add_child(asteroid)
	
	print("Asteroid spawned")
	
	var speed_multiplier : float = 0.1 * wave.current_wave
	
	# Run asteroid's start function, passing important parameter values
	asteroid.start(asteroid_type, planet, spawn_position, custom_asteroid_speed, custom_asteroid_speed_value, speed_multiplier, damage_number_toggle)
