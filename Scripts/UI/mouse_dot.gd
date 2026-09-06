extends Node2D


@onready var wave := WaveManager

@onready var dot: ColorRect = $ColorRect



@export var dot_size : float = 20




# - Displays dot in place of mouse for shop



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN	# Hides OS mouse
	
	wave.wave_complete.connect(_show_dot)
	wave.wave_started.connect(_hide_dot)
	
	dot.size = Vector2.ONE * dot_size
	dot.position = Vector2(-dot_size/2,-dot_size/2)

func _process(_delta: float) -> void:
	# Tracks dot to mouse lcoation
	dot.global_position = get_global_mouse_position()

# Shows dot on wave end
func _show_dot() -> void:
	dot.visible = true
	print("dot is set: true")
	print("dot is:", dot.visible)


# Hides dot on wave start
func _hide_dot() -> void:
	dot.visible = false
	print("dot is set: false")
	print("dot is:", dot.visible)
