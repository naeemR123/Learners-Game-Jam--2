extends Area2D

@onready var game := Game_Manager
@onready var wave := WaveManager
@onready var tracker := StatsManager

@onready var sprite : Sprite2D = $Sprite2D

const RESOURCE_SCENE = preload("uid://b8itoghsjeal8")
const DAMAGE_NUMBER = preload("uid://c7hnus72cghp0")
const DEATH_PARTICLES = preload("uid://f7ms6af6m58t")
const HIT_PARTICLES = preload("uid://y4r8isaruwon")



# - Debugging -
var damage_msgs : bool = false
# -

# - Properties -
# For Status Effect application
const DATA = "data"
const MAGNITUDE = "magnitude"
const REMAINING = "remaining"
const TICK_CLOCK = "tick_clock"

# Logs the origin of the effect and its properties
# source_key -> { DATA: StatusEffectData, MAGNITUDE: float, REMAINING: float, TICK_CLOCK: float }
var status_effects : Dictionary = {}
# Logs the effect and how much resistance
# effect : value (i.e. {"slow": 0.25} means 25% resistance to slowness)
var resistances : Dictionary = {}

var damage : float = 3
var current_health: float

var resource_min : int = 1
var resource_max : int = 3

var speed : float 
var speed_variance : float = 15
var max_speed : float = 300
var min_speed : float = 20
var direction : Vector2
# -

# - Despawning -
@onready var screen_size : Vector2 = get_viewport_rect().size
var despawn_margin : float = 350
# -

var hit_flash_tween : Tween
var rotation_speed : float = randf_range(-0.8,0.8)	# Random rotation : Purely visual

var planet: Area2D 			# Assigned at start()
var data : AsteroidData		# ^



# Runs immediately after entering the scene tree | Called from asteroid_spawner.gd
# Sets up asteroid with all necessary data and properties
func start(asteroid_type : AsteroidData, target_planet: Area2D, start_pos: Vector2, debug_speed: bool = false, debug_speed_value: float = 200, speed_multiplier: float = 1, damage_message_toggle: bool = false, health_multiplier: float = 1, damage_multiplier: float = 1.0) -> void:
	
	# Assigns variable to chosen asteroid type
	data = asteroid_type	# CRITICAL : Needs to be at top.
	
	# Safety Net : If no asteroid_type was given, aborts.
	if not data:
		despawn()
		push_warning("No AsteroidData loaded. Asteroid aborted.")
		return
	
	# Assigns variable to Planet, and position to determined spawn position
	planet = target_planet
	global_position = start_pos
	
	# Adds Asteroid to 'Asteroids' group
	add_to_group("Asteroids")
	
	# Connects Planet collision signal, if not already connected
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	
	
	###################################################################
	#  - Assigns properties based on attached AsteroidData resource - #
	
	if damage_message_toggle:
		damage_msgs = damage_message_toggle
	
	if debug_speed == true:		# If debug mode on, sets debug speed
		speed = debug_speed_value
	else: 
		# Assigns speed based on set min-max speed with speed_variance and wave's speed multiplier
		speed = clampf((randf_range(data.max_speed - speed_variance, data.max_speed + speed_variance) * speed_multiplier) + (min_speed/2), min_speed, max_speed)
	
	# Assigning properties
	current_health = data.max_health * health_multiplier
	# For Debugging
	#print("[DEBUG] Asteroid type: %s spawned with %.1f health | data.max_health set to %.1f, and health_multiplier set to %.1f" % [data.name, current_health, data.max_health, health_multiplier])
	rotation_speed = randf_range(-0.8, 0.8)
	sprite.texture = data.get_random_texture()
	damage = data.damage * damage_multiplier
	resource_min = data.min_resources
	resource_max = data.max_resources
	resistances =  data.resistances.duplicate()
	
	# Sets scale based on health and asteroid type's scale ratio
	scale = Vector2(data.scale_ratio, data.scale_ratio)
	
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
	print(" - Spawned: ", data.name , " at: ", global_position, " | Speed: ", speed, " | Scale: ", scale, " | Sprite Size: ", sprite.texture.get_size(), " | Health: ", current_health)


func _physics_process(delta: float) -> void:
	
	_tick_effects(delta)	# ticks status effects
	
	# Applies Slowness effect if there is one
	var scaled_delta = delta * (1.0 - get_modifier(EffectIDs.TIME_SCALE))
	
	# Produces movement and rotation
	global_position += direction * speed * scaled_delta
	rotation += rotation_speed * scaled_delta
	
	# Checks and despawns asteroid if off-screen by 'despawn_margin' amount
	if \
	global_position.x < -despawn_margin or \
	global_position.x > screen_size.x + despawn_margin or \
	global_position.y < -despawn_margin or \
	global_position.y > screen_size.y + despawn_margin:
		print(self, " despawned | Too far off screen")
		wave.asteroid_death()
		despawn()

# Counts down effects duration and deals PERIODIC Effects damage
func _tick_effects(delta: float) -> void:
	# .keys() creates a copy, so erasing is safe mid-loop
	for key in status_effects.keys():
		var effect = status_effects[key]	# A reference, not a copy
		
		# Counts down duration | if remaining <= 0 then it is permanent until remove_effect()
		if effect[REMAINING] > 0.0:
			effect[REMAINING] -= delta
			if effect[REMAINING] <= 0.0:
				status_effects.erase(key)
				continue
		
		# Fires periodic damage based on tick_interval (for burn, acid, etc.)
		if effect[DATA].family == StatusEffectsData.EffectsFamily.PERIODIC:
			effect[TICK_CLOCK] += delta
			if effect[TICK_CLOCK] >= effect[DATA].tick_interval:
				effect[TICK_CLOCK] -= effect[DATA].tick_interval
				take_damage(effect[MAGNITUDE], false)

# Applies (stores) status effect in Dictionary with resource values | Calculates local resistance
func apply_effect(source_key: String, effect_data:StatusEffectsData, magnitude: float, duration: float = -1.0) -> void:
	
	var resisted = magnitude * (1.0 - get_resistance(effect_data.id))
	status_effects[source_key] = {
		DATA: effect_data,
		MAGNITUDE: resisted,
		REMAINING: duration,
		TICK_CLOCK: 0.0,
	}

# Removes selected status effect from asteroid
func remove_effect(source_key: String) -> void:
	status_effects.erase(source_key)

# Retrieves resistance value for specified effect
func get_resistance(id: String) -> float:
	return resistances.get(id, 0.0)

# ONLY For MODIFIER effects | Returns a 0-1 reduction fraction; consumer applies (1.0 - result)
func get_modifier(stat_id: String) -> float:
	var strongest : float = 0.0
	for key in status_effects:
		var effect = status_effects[key]
		if effect[DATA].family == StatusEffectsData.EffectsFamily.MODIFIER\
		and effect[DATA].target_stat == stat_id:
			strongest = maxf(strongest, effect[MAGNITUDE])
	
	return strongest


# Processes collision damage to Planet and destroys asteroid
func _on_area_entered(body: Area2D) -> void:
	
	# Safety Net : Aborts if collision is not the Planet
	if body != planet:
		return
	else:
		tracker.increment(CounterIDs.ASTEROIDS_MISSED)
		game.take_damage(damage)	# Runs function in Game_Manager, tracking Planet shield
		wave.asteroid_death()		# Runs function in WaveManager, tracking asteroid death
		despawn()				# Deletes this instance
		


# Processes damage from Defenses
func take_damage(amount: float, particles: bool = true): 
	# Increments Stat Tracker
	tracker.increment(CounterIDs.DAMAGE_DEALT, minf(amount, current_health))
	current_health -= amount
	print(" Asteroid hit! Damage taken: %.1f | Current Health: %.1f" % [amount, current_health])
	
	# Hit Flash - Visual Effect
	# Kills pre-existing hit-flash before starting a new one
	if hit_flash_tween and hit_flash_tween.is_valid(): hit_flash_tween.kill()
	sprite.modulate = Color(4,4,4)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite, "modulate", Color(1,1,1), 0.1)
	
	# Emits damage number upon hit
	var damage_node = DAMAGE_NUMBER.instantiate()
	get_tree().current_scene.add_child(damage_node)
	damage_node.start(amount, global_position)
	if damage_msgs:
		print("[DEBUG] Damage Number triggered | Displays: %.1f" % amount)
	
	# Emits particles upon hit
	if particles:
		var hit_particles = HIT_PARTICLES.instantiate()
		get_tree().current_scene.call_deferred("add_child", hit_particles)
		hit_particles.call_deferred("start", direction, global_position)
	
	
	if current_health <=0:
		die()


# Destroys asteroid (from death by Defenses), dropping
# assigned amount of resources and tells WaveManager
func die():
	
	# Randomly chooses an amount based on the min and max values of resources, then spawns that amount
	var randamount = randi_range(resource_min, resource_max)
	for i in randamount:
		var resource = RESOURCE_SCENE.instantiate()
		resource.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", resource)
		resource.call_deferred("start")
	
	# Emits particles upon death
	var particles = DEATH_PARTICLES.instantiate()
	get_tree().current_scene.call_deferred("add_child", particles)
	particles.call_deferred("start", direction, global_position)
	
	tracker.increment(CounterIDs.ASTEROIDS_DESTROYED)
	wave.asteroid_death()	# Runs function in WaveManager, tracking asteroid death
	despawn()	# Deletes this instance


func despawn() -> void:
	queue_free()
