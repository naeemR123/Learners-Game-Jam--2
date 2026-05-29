extends Area2D

@onready var game := Game_Manager
@onready var wave := WaveManager

@onready var sprite : Sprite2D = $Sprite2D
@onready var resource_scene : PackedScene = preload("res://Scenes/resource.tscn")


# - Properties -
var damage : float = 3
var current_health: float
var local_time_scale : float = 1.0

var resource_max : int = 3
var resource_min : int = 1

var speed : float = randf_range(min_speed,max_speed)
var max_speed : float = 40
var min_speed : float = 15
var direction : Vector2
# -

var rotation_speed : float = randf_range(-0.8,0.8)	# Random rotation : Purely visual

var planet: Area2D 			# Assigned at start()
var data : AsteroidData		# ^



# Runs immediately after entering the scene tree | Called from asteroid_spawner.gd
# Sets up asteroid with all necessary data and properties
func start(asteroid_type : AsteroidData, target_planet: Area2D, start_pos: Vector2, debug_speed: bool = false, debug_speed_value: float = 200, speed_multiplier: float = 1, health_multiplier: float = 1) -> void:
	
	# Assigns variable to chosen asteroid type
	data = asteroid_type	# CRITICAL : Needs to be at top.
	
	# Safety Net : If no asteroid_type was given, aborts.
	if not data:
		queue_free()
		push_warning("No AsteroidData loaded. Asteroid aborted.")
		return
	
	# Assigns variable to Planet, and position to determined spawn position
	planet = target_planet
	global_position = start_pos
	
	# Connects Planet collision signal, if not already connected
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	
	
	###################################################################
	#  - Assigns properties based on attached AsteroidData resource - #
	
	if debug_speed == true:		# If debug mode on, sets debug speed
		speed = debug_speed_value
	else: 
		# Assigns speed based on asteroid's min-max speed and wave's speed multiplier
		speed = randf_range(data.min_speed, data.max_speed) * speed_multiplier
	
	# Assigning properties
	current_health = data.max_health * health_multiplier
	rotation_speed = randf_range(-0.8, 0.8)
	sprite.texture = data.sprite_texture
	
	# Sets scale based on health and asteroid type's scale ratio
	scale = Vector2(data.max_health * data.scale_ratio, data.max_health * data.scale_ratio)
	
	# Determines flight path | Comet vs. Other Asteroids
	if data.behavior == AsteroidData.BehaviorType.COMET:
		# Comets fly straight past the screen, avoiding the Planet
		# Picks a random vector moving roughly opposite
		var screen_center = get_viewport_rect().size/2
		var to_center = (screen_center - global_position).normalized()
		
		# Sets direction to fly past screen , avoiding the planet
		direction = to_center.rotated(randf_range(-0.5,0.5)) # Slight angle variation
	else:
		# Sets direciton towards the Planet
		direction = (planet.global_position - global_position).normalized()
	
	#																	#
	#####################################################################
	
	# Displays current Asteroid's info : name, pos, and speed
	print("Spawned: ", data.name , " at: ", global_position, " | Speed: ", speed)


func _physics_process(delta: float) -> void:
	# Produces movement and rotation
	global_position += direction * speed * local_time_scale * delta
	rotation += rotation_speed * local_time_scale * delta


# Processes damage from Defenses
func take_damage(amount: float): 
	current_health -= amount
	# Add hit-flash here
	if current_health <=0:
		die()


# Processes collision damage to Planet and destroys asteroid
func _on_area_entered(body: Area2D) -> void:
	
	# Safety Net : Aborts if collision is not the Planet
	if body != planet:
		return
	else:
		game.take_damage(damage)	# Runs function in Game_Manager, tracking Planet shield
		wave.asteroid_death()		# Runs function in WaveManager, tracking asteroid death
		queue_free()				# Deletes this instance
		print("Planet hit")


# Destroys asteroid (from death by Defenses), dropping
# assigned amount of resources and tells WaveManager
func die():
	# Randomly chooses an amount based on the min and max values of resources, then spawns that amount
	var randamount = randi_range(data.min_resources, data.max_resources)
	for i in randamount:
		var resource = resource_scene.instantiate()
		resource.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", resource)
	
	
	wave.asteroid_death()	# Runs function in WaveManager, tracking asteroid death
	queue_free()	# Deletes this instance
