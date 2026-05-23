extends Area2D



@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# Makes the radius of the collision shape 60% of the width of the sprite
	var spriteradius = sprite.texture.get_size()
	collision.shape.radius = ( spriteradius.x / 1.67)



func _process(_delta: float) -> void:
	# Tracks tractor beam to mouse lcoation
	global_position = get_global_mouse_position()
	
	# When Left Mouse is held, enables collisions and shows 
	# sprite at 50% opacity, otherwise does nothing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		collision.disabled = false
		sprite.modulate.a = 0.5
	else:
		collision.disabled = true
		sprite.modulate.a = 0
