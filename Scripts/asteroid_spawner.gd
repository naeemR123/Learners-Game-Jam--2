extends Marker2D


@onready var wave := WaveManager


@export var debug_speed : bool = false
@export var debug_speed_value : float = 200

@export var margin: float = 100.0 # How far offscreen to spawn

var asteroid_scene: PackedScene = preload("res://Scenes/asteroid.tscn")

var amount_spawned : int = 0

@onready var spawntimer: Timer = $SpawnCooldown
@onready var planet : Area2D = get_tree().get_first_node_in_group("Planet")



func _ready() -> void:
	wave.timer_interval.connect(timer_info)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func timer_info(interval : float) -> void:
	spawntimer.start(interval)


func _on_spawn_cooldown_timeout() -> void:
	var type = WaveManager.get_next_asteroid()
	if type == null:
		spawntimer.stop()
	spawn_asteroid(type)

func spawn_asteroid(asteroid_type) -> void:
	if asteroid_scene == null: 
		push_warning("Cannot spawn Asteroid: No scene loaded (from: asteroid_spawner/spawn_asteroid)")
		return
		
	var viewport_size = get_viewport_rect().size
	
	# Chooses random screen edge (0 = top, 1 = bottom, 2 = left, 3 = right)
	var edge = randi() % 4 # <- chooses random number between 0 and 3
	var spawn_position : Vector2

	match edge:
		0: # Top edge
			spawn_position = Vector2(
				randf_range(0, viewport_size.x), 	# x value 
				-margin								# y value
				)
		1: # Bottom edge
			spawn_position = Vector2(
				randf_range(0, viewport_size.x), 	# x value 
				viewport_size.y + margin			# y value
				)
		2: # Left edge
			spawn_position = Vector2(
				-margin, 							# x value 
				randf_range(0, viewport_size.y)		# y value
				)
		3: # Right edge
			spawn_position = Vector2(
				viewport_size.x + margin, 			# x value 
				randf_range(0, viewport_size.y)		# y value
				)
	
	# Instance the asteroid, add it to the scene, and sets position
	var asteroid = asteroid_scene.instantiate()
	
	# CRITICAL FIX: Add to the main scene, NOT the Marker2D spawner.
	# This prevents the asteroid from inheriting the spawner's transform.
	get_tree().current_scene.add_child(asteroid)
	wave.asteroid_spawned()
	print("Asteroid spawned")
	
	asteroid.start(asteroid_type, planet, spawn_position, debug_speed, debug_speed_value, )
	
