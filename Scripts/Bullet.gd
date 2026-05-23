# res://scripts/Bullet.gd
extends Area2D

var speed = 500
var direction = Vector2.RIGHT
var damage = 1

func _ready():
	# Connect collision signal to detect hits
	body_entered.connect(_on_body_entered)
	# Auto-destroy after a few seconds to avoid infinite bullets
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("asteroid"):
		body.take_damage(damage)
		queue_free()
