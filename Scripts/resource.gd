extends Area2D

# - Despawning -
@onready var timer: Timer = $DespawnTimer

@onready var screen_size : Vector2 = get_viewport_rect().size
@export var despawn_time : int = 90 # seconds
@export var despawn_margin : float = 300.0
# -

var speed := randf_range(20,50)					# Sets random speed
var direction : Vector2
var rotation_speed : float = randf_range(-4,4)	# Sets random rotation speed



# - Claiming behavior -
var claimed_by : Node = null
var claim_frame : int = -1
var claim_distance : float = INF
# -

var swarm_offset_val : int = 8
var swarm_offset : Vector2


func start() -> void:
	
	timer.start(despawn_time)
	
	direction = Vector2(randf_range(-1,1),randf_range(-1,1))		# Sets a random direction
	#print("Resource spawned | Position: ", global_position, " | Direction: ", direction)
	
	swarm_offset = Vector2(randf_range(-swarm_offset_val,swarm_offset_val),randf_range(-swarm_offset_val,swarm_offset_val))	# Sets a random offset when clustered
	


func _process(delta: float) -> void:
	# Produces movement and rotation
	global_position += direction * speed * delta
	rotation += rotation_speed * delta
	
	if \
	global_position.x < -despawn_margin or \
	global_position.x > screen_size.x + despawn_margin or \
	global_position.y < -despawn_margin or \
	global_position.y > screen_size.y + despawn_margin:
		print("Resource despawned : Too far off screen")
		despawn()


func _on_timer_timeout() -> void:
	print("Resource despawned : Timed out")
	despawn()


func despawn() -> void:
	queue_free()
