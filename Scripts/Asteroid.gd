# res://scripts/Asteroid.gd
extends Area2D

var speed = 100
var direction = Vector2.DOWN
var health = 3
@export var resource_scene: PackedScene   # Assign the ResourcePickup scene

@onready var hit_timer = null   # optional: flash when hit (set if HitTimer node exists)

func _ready():
	add_to_group("asteroid")
	# Connect both body_entered and area_entered so we catch collisions with bodies and areas
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)

func _physics_process(delta):
	position += direction * speed * delta

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	# Spawn a resource pickup
	var res = resource_scene.instantiate()
	get_parent().add_child(res)
	res.global_position = global_position
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("planet"):
		# Damage the planet – we’ll add later
		queue_free()
