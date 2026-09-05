extends Resource
class_name ResourceData


enum ResourceType { GREY, BLUE, GOLD, RED, }



@export var resource_type : ResourceType = ResourceType.GREY
@export var value : int

@export_category("Texture")
@export var textures : Array[Texture2D]
@export var glow : bool = false
@export var glow_color : Color

@export_category("Spawning")
@export var min_wave : int = 0
@export var base_weight : float



func get_random_texture() -> Texture2D:
	if textures.is_empty():
		var placeholder := PlaceholderTexture2D.new()
		placeholder.size = Vector2(25,25)
		return placeholder
	return textures.pick_random()
