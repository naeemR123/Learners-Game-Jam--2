extends Area2D


@onready var game := Game_Manager


@onready var collector_range : CollisionShape2D = $Range
@onready var collection_zone : Area2D = $CollectionZone


var my_id : String
var my_range : float = 100.0
var my_collection_speed : float = 80
var my_gravity_strength : float = 0.5

func initialize(data: SatelliteData) -> void:
	my_id = data.id


func _ready() -> void:
	
	collection_zone.area_entered.connect(_on_collection_area_entered)	# Connects the Area2D signals via code
	collector_range.shape = collector_range.shape.duplicate()
	
	game.stats_changed.connect(update_satellite_stats)
	update_satellite_stats()


func update_satellite_stats():
	my_collection_speed = game.active_stats[my_id][StatIDs.SAT_COLLECTION_SPEED]
	my_gravity_strength = game.active_stats[my_id][StatIDs.SAT_GRAVITY_STRENGTH]
	my_range = game.active_stats[my_id][StatIDs.RANGE]
	collector_range.shape.radius = my_range


func _physics_process(delta: float) -> void:
	var caught_resources = get_overlapping_areas()
	var current_frame = Engine.get_physics_frames()
	
	for resource in caught_resources:
		
		if "speed" in resource and "direction" in resource:
			
			# Adds slight variation between resources - prevents overlapping when released
			var target_pos = global_position
			if "swarm_offset" in resource:
				target_pos += resource.swarm_offset
			
			var distance = global_position.distance_to(resource.global_position)
			
			if resource.claim_frame != current_frame or distance < resource.claim_distance:
				resource.claimed_by = self
				resource.claim_frame = current_frame
				resource.claim_distance = distance
			
			if self != resource.claimed_by:
				continue
			
			
			# Calculate the direction towards the satellite
			var current_velocity = resource.direction * resource.speed
			var pull_direction = (target_pos - resource.global_position).normalized()
			var desired_velocity = pull_direction * my_collection_speed
			
			# Smoothly moves the vector, even through 0- naturally reversing it.
			var new_velocity = current_velocity.lerp(desired_velocity, my_gravity_strength * delta)
			
			# Smoothly increase or decrease its speed to match the satellite's pull
			resource.speed = new_velocity.length()
			
			if resource.speed > 0.01: # CRITICAL Prevents divide by 0 error
				# Smoothly bends the resource's current flying direction toward the satellite
				resource.direction = new_velocity.normalized()



# Mask is set to 4, meaning 'area' is guaranteed to be a Resource
func _on_collection_area_entered(area: Area2D) -> void: 
	game.add_resource(1)
	area.despawn()
