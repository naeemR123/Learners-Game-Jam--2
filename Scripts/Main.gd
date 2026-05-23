# res://scripts/Main.gd
extends Node2D

@export var asteroid_scene: PackedScene
@export var spawn_interval = 2.0
@export var game_area: Rect2 = Rect2(Vector2(0, 0), Vector2(1920, 1080))

var rng = RandomNumberGenerator.new()

func _ready():
	$SpawnTimer.wait_time = spawn_interval
	$SpawnTimer.timeout.connect(_spawn_asteroid)
	$SpawnTimer.start()

func _spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	add_child(asteroid)
	# Spawn at a random edge of the screen
	var side = rng.randi_range(0, 3)
	match side:
		0: # top
			asteroid.global_position = Vector2(rng.randf_range(game_area.position.x, game_area.end.x), game_area.position.y)
			asteroid.direction = Vector2.DOWN
		1: # bottom
			asteroid.global_position = Vector2(rng.randf_range(game_area.position.x, game_area.end.x), game_area.end.y)
			asteroid.direction = Vector2.UP
		2: # left
			asteroid.global_position = Vector2(game_area.position.x, rng.randf_range(game_area.position.y, game_area.end.y))
			asteroid.direction = Vector2.RIGHT
		3: # right
			asteroid.global_position = Vector2(game_area.end.x, rng.randf_range(game_area.position.y, game_area.end.y))
			asteroid.direction = Vector2.LEFT
	# Aim roughly toward the planet (center)
	var to_planet = (Vector2(game_area.end.x/2, game_area.end.y/2) - asteroid.global_position).normalized()
	asteroid.direction = to_planet
