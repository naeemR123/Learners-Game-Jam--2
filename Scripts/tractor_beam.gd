extends Area2D

var pulling = false

func _ready():
	# Connect signals: when a resource enters the area, collect it
	body_entered.connect(_on_body_entered)
	# Make sure we only detect the "resources" layer later
	collision_mask = 2   # We'll put resources on layer 2

func _process(_delta):
	# Make the beam follow the mouse
	position = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Visually indicate the beam is active (we’ll add a sprite later)
		pulling = true
	else:
		pulling = false

func _on_body_entered(body):
	if body.is_in_group("resource"):
		# Tell the resource to be collected
		body.collect()
