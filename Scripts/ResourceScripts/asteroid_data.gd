extends Resource
class_name AsteroidData

enum BehaviorType { DEFAULT, COMET, BOSS }

@export_category("Visuals")
@export var name: String
@export var sprite_texture: Texture2D
@export var scale_ratio: float = 1
var	base_scale: Vector2 = Vector2(max_health*scale_ratio,max_health*scale_ratio)

@export_category("Base Stats")
@export var max_health: float
@export var min_speed: float
@export var max_speed: float
@export var slow_resistance: float = 0.0

@export_category("Drops")
@export var min_resources: int = 1
@export var max_resources: int

@export_category("AI")
@export var behavior: BehaviorType = BehaviorType.DEFAULT
