extends Area2D



@onready var sprite: Sprite2D = $Sprite2D
@onready var light: PointLight2D = $PointLight2D
@onready var planet : Node = get_tree().get_first_node_in_group("Planet")

# - Despawning -
@onready var timer: Timer = $DespawnTimer
@export var despawn_time : int = 60 # seconds
@export var despawn_margin : float = 2000.0
# -

# - Properties -
var my_data : ResourceData
var value : int

var speed := randf_range(20,50)					# Sets random speed
var direction : Vector2
var rotation_speed : float = randf_range(-4,4)	# Sets random rotation speed
# -

# - Claiming behavior -
var claimed_by : Node = null
var claim_frame : int = -1
var claim_distance : float = INF
# -

var swarm_offset_val : int = 8
var swarm_offset : Vector2



func initialize(data: ResourceData, pos: Vector2) -> void:
	my_data = data
	value = data.value
	sprite.texture = data.get_random_texture()
	
	if data.glow:
		light.enabled = data.glow
		light.color = data.glow_color
	
	global_position = pos
	direction = Vector2(randf_range(-1,1),randf_range(-1,1))		# Sets a random direction
	#print("Resource spawned | Position: ", global_position, " | Direction: ", direction)
	
	# Sets a random offset when clustered
	swarm_offset = Vector2(randf_range(-swarm_offset_val,swarm_offset_val),randf_range(-swarm_offset_val,swarm_offset_val))

	timer.start(despawn_time)


func _process(delta: float) -> void:
	# Produces movement and rotation
	global_position += direction * speed * delta
	rotation += rotation_speed * delta
	
	if global_position.distance_to(planet.global_position) > despawn_margin:
		print("Resource despawned : Too far off screen")
		despawn()


func _on_timer_timeout() -> void:
	print("Resource despawned : Timed out")
	despawn()


func despawn() -> void:
	queue_free()
