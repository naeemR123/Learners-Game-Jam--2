# res://scripts/AutoCannon.gd
extends Node2D

@export var bullet_scene: PackedScene   # We'll create this later
@export var fire_rate = 1.0

var target: Node2D = null
var enemies_in_range = []

@onready var fire_timer = $FireTimer

func _ready():
	$DetectionRadius.area_entered.connect(_on_detection_area_entered)
	$DetectionRadius.area_exited.connect(_on_detection_area_exited)
	fire_timer.timeout.connect(_fire)
	# Update fire timer interval if exported later
	fire_timer.wait_time = fire_rate
	# Start the firing timer so the cannon will actually fire when enemies are present
	fire_timer.start()

func _on_detection_area_entered(area):
	if area.is_in_group("asteroid"):
		enemies_in_range.append(area)
		if not target or target == null:
			target = area

func _on_detection_area_exited(area):
	if area.is_in_group("asteroid"):
		enemies_in_range.erase(area)
		if target == area:
			update_target()

func update_target():
	# Choose the closest enemy in range
	var closest = null
	var min_dist = INF
	for e in enemies_in_range:
		if e != null and is_instance_valid(e):
			var d = e.global_position.distance_to(global_position)
			if d < min_dist:
				min_dist = d
				closest = e
	target = closest

func _fire():
	if target == null or not is_instance_valid(target):
		update_target()
	if target == null:
		return
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = (target.global_position - global_position).normalized()
	# Rotate the cannon to face the target (optional)
	rotation = bullet.direction.angle()
