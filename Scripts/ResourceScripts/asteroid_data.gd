extends Resource
class_name AsteroidData

enum BehaviorType { DEFAULT, COMET, BOSS }

@export_category("Visuals")
@export var name : String
@export var sprite_textures : Array[Texture2D] = []
@export var scale_ratio : float = 1

@export_category("Base Stats")
@export var max_health : float
@export var max_speed : float
@export var damage : float
@export var slow_resistance : float = 0.0

@export_category("Spawning")
@export var min_wave : int
@export var spawn_weight : float 

@export_category("Drops")
@export var min_resources : int = 1
@export var max_resources : int

@export_category("AI")
@export var behavior : BehaviorType = BehaviorType.DEFAULT

# Chooses random texture from Array | Applies a placeholder if empty
func get_random_texture() -> Texture2D:
	if sprite_textures.is_empty():
		var placeholder := PlaceholderTexture2D.new()
		placeholder.size = Vector2(50,50)
		return placeholder
	return sprite_textures.pick_random()
