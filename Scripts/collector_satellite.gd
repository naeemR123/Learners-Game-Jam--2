extends Node2D


@onready var game := Game_Manager


@export var orbit_speed : float = 0.2
@export var collection_speed : float = 100
@export var collection_strength : float = 5

@onready var satellite: Area2D = $Satellite
@onready var collection_zone: Area2D = $Satellite/CollectionZone
@onready var planet: Area2D = %Planet


func _ready() -> void:
	
	if planet:
		global_position = planet.global_position
	
	satellite.position.x = randf_range(125, 200)
	print("Satelitte pos: ",satellite.position)
	# Connects the Area2D signals via code
	collection_zone.area_entered.connect(_on_collection_area_entered)


func _process(delta: float) -> void:
	
	# Rotates the pivot to make the satellite orbit
	rotation += orbit_speed * delta


func _physics_process(delta: float) -> void:
	var caught_resources = satellite.get_overlapping_areas()
	
	for resource in caught_resources:
		
		if "speed" in resource and "direction" in resource:
			
			var current_velocity = resource.direction * resource.speed
			
			# Adds slight variation between resources - prevents overlapping when released
			var target_pos = satellite.global_position
			if "swarm_offset" in resource:
				target_pos += resource.swarm_offset
			
			# Calculate the direction towards the satellite
			var pull_direction = (target_pos - resource.global_position).normalized()
			var desired_velocity = pull_direction * collection_speed
			
			# Smoothly moves the vector, even through 0- naturally reversing it.
			var new_velocity = current_velocity.lerp(desired_velocity, collection_strength * delta)
			
			# Smoothly increase or decrease its speed to match the satellite's pull
			resource.speed = new_velocity.length()
			
			if resource.speed > 0.01: # CRITICAL Prevents divide by 0 error
				# Smoothly bends the resource's current flying direction toward the satellite
				resource.direction = new_velocity.normalized()



# Mask is set to 4, meaning 'area' is guaranteed to be a Resource
func _on_collection_area_entered(area: Area2D) -> void: 
	game.add_resource(1)
	area.queue_free()
