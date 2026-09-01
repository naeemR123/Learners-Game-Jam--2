extends Camera2D


@onready var game := Game_Manager

@onready var shop_panel := get_tree().current_scene.get_node("UI/ShopPanel")

@export_category("Settings")

@export_group("Shop Slide")
@export var shop_slide_duration : float = 2
@export var shop_slide_trans : Tween.TransitionType = Tween.TRANS_QUINT
@export var shop_slide_ease : Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Screen Shake")
@export_range(0, 30, 0.5, "or_greater") var shake_amount : float = 10
@export_range(1, 50, 0.5, "or_greater") var shake_decay : float = 25.0

@export_group("Parallax")
@export_range(0,10,0.5) var mouse_parallax_strength : float = 6.0 # from 1 - 10

@export_group("")

var shake_strength : float = 0.0

var shop_offset : Vector2 = Vector2.ZERO
var shop_tween : Tween


func _ready() -> void:
	
	game.shield_changed.connect(_on_shield_changed)
	shop_offset = _get_shop_slide_target()

func _on_shield_changed() -> void:
	shake_strength = shake_amount


func _process(delta: float) -> void:
	var mouse_offset = get_mouse_parallax_offset()
	var shake_offset = Vector2(randf_range(-1,1), randf_range(-1,1)) * shake_strength
	
	offset =  mouse_offset + shake_offset + shop_offset
	
	if shake_strength > 0:
		shake_strength = move_toward(shake_strength, 0, shake_decay * delta)


func get_mouse_parallax_offset() -> Vector2:
	
	var viewport_size = get_viewport_rect().size
	var center = viewport_size / 2
	var mouse_pos = get_viewport().get_mouse_position()
	
	var normalized_mouse_offset = (mouse_pos - center)/center
	var parallax_strength = mouse_parallax_strength*5
	
	return normalized_mouse_offset * parallax_strength

# Tweens camera to the right | Called via ui._shop_ui()
func set_shop_open(is_open: bool) -> void:
	var target = _get_shop_slide_target() if is_open else Vector2.ZERO
	
	if shop_tween:
		shop_tween.kill()	# Quickly stops in-progress motion
	
	shop_tween = create_tween()
	shop_tween.set_trans(shop_slide_trans)
	shop_tween.set_ease(shop_slide_ease)
	shop_tween.tween_property(self, "shop_offset", target, shop_slide_duration)

# Reads shop_panels width to dynamically adjust to any screen size
func _get_shop_slide_target() -> Vector2:
	var viewport_width = get_viewport_rect().size.x
	var panel_fraction = shop_panel.anchor_right
	var shift_pixels = (panel_fraction / 2.0) * viewport_width
	
	return Vector2(-shift_pixels / zoom.x, 0)
